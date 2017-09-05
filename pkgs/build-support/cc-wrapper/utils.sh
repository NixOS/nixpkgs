mangleVarList() {
    local var="$1"
    shift
    local -a role_infixes=("$@")

    local outputVar="${var/+/_@infixSalt@_}"
    declare -gx ${outputVar}+=''
    # For each role we serve, we accumulate the input parameters into our own
    # cc-wrapper-derivation-specific environment variables.
    for infix in "${role_infixes[@]}"; do
        local inputVar="${var/+/${infix}}"
        if [ -v "$inputVar" ]; then
            export ${outputVar}+="${!outputVar:+ }${!inputVar}"
        fi
    done
}

mangleVarBool() {
    local var="$1"
    shift
    local -a role_infixes=("$@")

    local outputVar="${var/+/_@infixSalt@_}"
    declare -gxi ${outputVar}+=''
    for infix in "${role_infixes[@]}"; do
        local inputVar="${var/+/${infix}}"
        if [ -v "$inputVar" ]; then
            let "${outputVar} |= ${!inputVar}"
        fi
    done
}

skip () {
    if [ -n "${NIX_DEBUG:-}" ]; then
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
    declare -ga params=("$@")
    local arg
    for arg in "$@"; do
        if [[ "$arg" == @* ]]; then
            # phase separation makes this look useless
            # shellcheck disable=SC2157
            if [ -x "@expandResponseParams@" ]; then
                # params is used by caller
                #shellcheck disable=SC2034
                readarray -d '' params < <("@expandResponseParams@" "$@")
                return 0
            else
                echo "Response files aren't supported during bootstrapping" >&2
                return 1
            fi
        fi
    done
}
