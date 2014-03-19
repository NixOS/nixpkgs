#! @bash@/bin/sh -e

usage() {
    echo "Usage: $0 login <container-name>" >&2
    echo "       $0 root-shell <container-name>" >&2
}

args="`getopt --options '' -l help -- "$@"`"
eval "set -- $args"
while [ $# -gt 0 ]; do
    case "$1" in
        (--help) usage; exit 0;;
        (--) shift; break;;
        (*) break;;
    esac
    shift
done

action="$1"
if [ -z "$action" ]; then usage; exit 1; fi
shift

getContainerRoot() {
    root="/var/lib/containers/$container"
    if ! [ -d "$root" ]; then
        echo "$0: container ‘$container’ does not exist" >&2
        exit 1
    fi
}

if [ $action = login ]; then

    container="$1"
    if [ -z "$container" ]; then usage; exit 1; fi
    shift

    getContainerRoot

    exec @socat@/bin/socat "unix:$root/var/lib/login.socket" -,echo=0,raw

elif [ $action = root-shell ]; then

    container="$1"
    if [ -z "$container" ]; then usage; exit 1; fi
    shift

    getContainerRoot

    exec @socat@/bin/socat "unix:$root/var/lib/root-shell.socket" -

else
    echo "$0: unknown action ‘$action’" >&2
    exit 1
fi
