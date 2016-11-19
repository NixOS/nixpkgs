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

expandResponseParams() {
    local inparams=("$@")
    local n=0
    local p
    params=()
    while [ $n -lt ${#inparams[*]} ]; do
        p=${inparams[n]}
        case $p in
            @*)
                if [ -e "${p:1}" ]; then
                    args=$(<"${p:1}")
                    eval 'for arg in '${args//$/\\$}'; do params+=("$arg"); done'
                else
                    params+=("$p")
                fi
                ;;
            *)
                params+=("$p")
                ;;
        esac
        n=$((n + 1))
    done
}
