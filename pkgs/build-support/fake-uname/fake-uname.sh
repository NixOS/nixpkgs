#!@shell@

declare -a unameTuple
unameTuple=(@unameTuple@)

usage() {
    echo "$0: a fake uname(1) implementation provided by nixpkgs. See 'man uname' for usage." >&2
    exit 1
}

# Resolve long options first. Bash getopt is too lame.
declare -a argv
for opt in "$@"; do
    case "$opt" in
        --all)               opt=-a;;
        --kernel-name)       opt=-s;;
        --nodename)          opt=-n;;
        --kernel-release)    opt=-r;;
        --release)           opt=-r;;
        --kernel-version)    opt=-v;;
        --machine)           opt=-m;;
        --processor)         opt=-p;;
        --hardware-platform) opt=-i;;
        --operating-system)  opt=-o;;
    esac
    argv+=("$opt")
done

set -- "${argv[@]}"

allowedOpts=snrvmpioa
mask=0
while getopts "$allowedOpts" opt; do
    case "$opt" in
        \?)
            usage
            ;;
        a)
            # 'uname -a' prints all fields, except unknown ones. Matches coreutils uname behaviour.
            mask=255
            hideUnknown=1
            ;;
        *)
            mask=$(( $mask | ( 1 << $(expr index $allowedOpts $opt) - 1 ) ))
            ;;
    esac
done
shift "$((OPTIND-1))"

if [ $# -gt 0 ]; then
    echo "$0: extra operand '$1'" >&2
    usage
fi

# Just 'uname' is equivalent to 'uname -s'
if [ "$mask" -eq 0 ]; then
    mask=1
fi

first=1
for (( i=0; i<${#unameTuple[@]}; i++ )); do
    if ! (( mask & (1 <<  i) )); then
        continue
    fi
    s=${unameTuple[$i]}
    if [ -n "$hideUnknown" ] && [ "$s" = unknown ]; then
        continue
    fi

    if [ -z "$first" ]; then
        echo -n ' '
    fi
    first=
    echo -n "$s"
done
echo
