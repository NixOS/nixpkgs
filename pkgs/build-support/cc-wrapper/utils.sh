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
# Push (a) arg or (c) char on transition:
rspP[10]=a rspP[01]=c rspP[11]=c rspP[21]=c rspP[33]=c rspP[43]=c rspP[55]=c rspP[65]=c

rspParse() {
    rsp=()
    local state=0
    local arg=''
    local c

    while read -r -N1 c; do
        local cls=1
        case "$c" in
            ' ' | $'\t' | $'\r' | $'\n') cls=0 ;;
            '\') cls=2 ;;
            "'") cls=3 ;;
            '"') cls=4 ;;
        esac
        local nextstates="${rspT[$state]}"
        local nextstate="${nextstates:$cls:1}"
        case "${rspP[$state$nextstate]}" in
            'c') arg+="$c" ;;
            'a') rsp+=("$arg"); arg='' ;;
        esac
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
            rspParse <"${p:1}"
            set -- "${rsp[@]}" "$@"
        else
            params+=("$p")
        fi
    done
}
