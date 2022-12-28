# Accumulate suffixes for taking in the right input parameters with the `mangle*`
# functions below. See setup-hook for details.
accumulateRoles() {
    declare -ga role_suffixes=()
    if [ "${NIX_@wrapperName@_TARGET_BUILD_@suffixSalt@:-}" ]; then
        role_suffixes+=('_FOR_BUILD')
    fi
    if [ "${NIX_@wrapperName@_TARGET_HOST_@suffixSalt@:-}" ]; then
        role_suffixes+=('')
    fi
    if [ "${NIX_@wrapperName@_TARGET_TARGET_@suffixSalt@:-}" ]; then
        role_suffixes+=('_FOR_TARGET')
    fi
}

mangleVarListGeneric() {
    local sep="$1"
    shift
    local var="$1"
    shift
    local -a role_suffixes=("$@")

    local outputVar="${var}_@suffixSalt@"
    declare -gx "$outputVar"+=''
    # For each role we serve, we accumulate the input parameters into our own
    # cc-wrapper-derivation-specific environment variables.
    for suffix in "${role_suffixes[@]}"; do
        local inputVar="${var}${suffix}"
        if [ -v "$inputVar" ]; then
            export "${outputVar}+=${!outputVar:+$sep}${!inputVar}"
        fi
    done
}

mangleVarList() {
    mangleVarListGeneric " " "$@"
}

mangleVarBool() {
    local var="$1"
    shift
    local -a role_suffixes=("$@")

    local outputVar="${var}_@suffixSalt@"
    declare -gxi "${outputVar}+=0"
    for suffix in "${role_suffixes[@]}"; do
        local inputVar="${var}${suffix}"
        if [ -v "$inputVar" ]; then
            # "1" in the end makes `let` return success error code when
            # expression itself evaluates to zero.
            # We don't use `|| true` because that would silence actual
            # syntax errors from bad variable values.
            let "${outputVar} |= ${!inputVar:-0}" "1"
        fi
    done
}

# Combine a singular value from all roles. If multiple roles are being served,
# and the value differs in these roles then the request is impossible to
# satisfy and we abort immediately.
mangleVarSingle() {
    local var="$1"
    shift
    local -a role_suffixes=("$@")

    local outputVar="${var}_@suffixSalt@"
    for suffix in "${role_suffixes[@]}"; do
        local inputVar="${var}${suffix}"
        if [ -v "$inputVar" ]; then
            if [ -v "$outputVar" ]; then
                if [ "${!outputVar}" != "${!inputVar}" ]; then
                    {
                        echo "Multiple conflicting values defined for $outputVar"
                        echo "Existing value is ${!outputVar}"
                        echo "Attempting to set to ${!inputVar} via $inputVar"
                    } >&2

                    exit 1
                fi
            else
                declare -gx ${outputVar}="${!inputVar}"
            fi
        fi
    done
}

skip () {
    if (( "${NIX_DEBUG:-0}" >= 1 )); then
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
        "${p#"${NIX_STORE}"}"     = "$p" -a \
        "${p#"${NIX_BUILD_TOP}"}" = "$p" -a \
        "${p#/tmp}"               = "$p" -a \
        "${p#"${TMP:-/tmp}"}"     = "$p" -a \
        "${p#"${TMPDIR:-/tmp}"}"  = "$p" -a \
        "${p#"${TEMP:-/tmp}"}"    = "$p" -a \
        "${p#"${TEMPDIR:-/tmp}"}" = "$p"
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
            fi
        fi
    done
}

checkLinkType() {
    local arg
    type="dynamic"
    for arg in "$@"; do
        if [[ "$arg" = -static ]]; then
            type="static"
        elif [[ "$arg" = -static-pie ]]; then
            type="static-pie"
        fi
    done
    echo "$type"
}

# When building static-pie executables we cannot have rpath
# set. At least glibc requires rpath to be empty
filterRpathFlags() {
    local linkType=$1 ret i
    shift

    if [[ "$linkType" == "static-pie" ]]; then
        while [[ "$#" -gt 0 ]]; do
            i="$1"; shift 1
            if [[ "$i" == -rpath ]]; then
                # also skip its argument
                shift
            else
                ret+=("$i")
            fi
        done
    else
        ret=("$@")
    fi
    echo "${ret[@]}"
}
