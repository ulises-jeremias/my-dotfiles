############################################
################################# KUBERNETES

kubeconfigenv() {
    export KUBECONFIG="${HOME}/.kube/${1}"
}

kubeclear() {
    export KUBECONFIG=
}

############################################
######################################### AU

kubestaging() {
    kubeconfigenv au-staging
}

kubeprod() {
    kubeconfigenv au-prod
}

kubemanagement() {
    for pod in $(printf $(kubectl -n management get pods | grep management | awk '{print $1}')); do
        echo $pod
        kubectl -n management exec -it "${pod}" -- /bin/bash
    done
}

gointomanypodsstaging() {
    for s in $(kubestaging && kubectl -n $1 get pods | tail -n+2 | awk '{print $1}'); do
        tab "kubestaging && kubectl -n $1 exec -it $s /bin/bash"
    done
}

gointomanypodsprod() {
    for s in $(kubeprod && kubectl -n $1 get pods | tail -n+2 | awk '{print $1}'); do
        tab "kubeprod && kubectl -n $1 exec -it $s /bin/bash"
    done
}

tab() {
    local cmd=""
    local cdto="$PWD"
    local args=$@

    if [ -d "$1" ]; then
        cdto=$(cd "$1"; pwd)
        args="${@:2}"
    fi

    if [ -n "$args" ]; then
        cmd="$args"
    fi

    alacritty -e "/usr/bin/zsh -c \"${cmd}\""
}
