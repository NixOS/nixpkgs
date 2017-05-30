skip () {
    if [ -n "$NIX_DEBUG" ]; then
        echo "skipping impure path $1" >&2
    fi
}


# Checks whether a path is impure.  E.g., `/lib/foo.so' is impure, but
# `/nix/store/.../lib/foo.so' isn't.
badPath() {
    local p=$1

    # Relative paths are okay (since they're presumably relative to
    # the temporary build directory).
    if [ "${p:0:1}" != / ]; then return 1; fi

    # Otherwise, the path should refer to the store or some temporary
    # directory (including the build directory).
    test \
        "$p" != "/dev/null" -a \
        "${p:0:${#NIX_STORE}}" != "$NIX_STORE" -a \
        "${p:0:4}" != "/tmp" -a \
        "${p:0:${#NIX_BUILD_TOP}}" != "$NIX_BUILD_TOP"
}

# @args.rsp parser.
# Char classes: space, other, backslash, single quote, double quote.
# States: 0 - outside, 1/2 - unquoted arg/slash, 3/4 - 'arg'/slash, 5/6 - "arg"/slash.
# State transitions:
rspT=(01235 01235 11111 33413 33333 55651 55555)
# Push char on transition:
rspC[01]=1 rspC[11]=1 rspC[21]=1 rspC[33]=1 rspC[43]=1 rspC[55]=1 rspC[65]=1

rspParse() {
    rsp=()
    local s="$1"
    local state=0
    local arg=''

    for (( i=0; i<${#s}; i++ )); do
        local c="${s:$i:1}"
        local cls=1
        case "$c" in
            ' ' | $'\t' | $'\r' | $'\n') cls=0 ;;
            '\') cls=2 ;;
            "'") cls=3 ;;
            '"') cls=4 ;;
        esac
        local nextstates="${rspT[$state]}"
        local nextstate="${nextstates:$cls:1}"
        if [ "${rspC[$state$nextstate]}" ]; then
            arg+="$c"
        elif [ "$state$nextstate" = "10" ]; then
            rsp+=("$arg")
            arg=''
        fi
        state="$nextstate"
    done

    if [ "$state" -ne 0 ]; then
        rsp+=("$arg")
    fi
}

expandResponseParams() {
    params=()
    while [ $# -gt 0 ]; do
        local p="$1"
        shift
        if [ "${p:0:1}" = '@' -a -e "${p:1}" ]; then
            rspParse "$(<"${p:1}")"
            set -- "${rsp[@]}" "$@"
        else
            params+=("$p")
        fi
    done
}
