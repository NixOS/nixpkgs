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

skip() {
    if (( "${NIX_DEBUG:-0}" >= 1 )); then
        echo "skipping impure path $1" >&2
    fi
}

reject() {
    echo "impure path \`$1' used in link" >&2
    exit 1
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

# Like `badPath`, but handles paths that may be interpreted relative to
# `$SDKROOT` on Darwin. For example, `-L/usr/lib/swift` is interpreted
# as `-L$SDKROOT/usr/lib/swift` when `$SDKROOT` is set and
# `$SDKROOT/usr/lib/swift` exists.
badPathWithDarwinSdk() {
    path=$1
    if [[ "@darwinMinVersion@" ]]; then
        sdkPath=$SDKROOT/$path
        if [[ -e $sdkPath ]]; then
            path=$sdkPath
        fi
    fi
    badPath "$path"
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

# Resolve the path $1 of a library directory, which like the linker
# takes a relative path from the working directory, to the directory the
# linker searches, as far as needed to tell whether it is in the store,
# and where.  Like the kernel, follow each symlink before going on to the
# next component, so that symlinks in ancestor directories count, and `..`
# applies to the target of a symlink rather than removing it.  But in the
# store, keep symlinks that are not followed by `..` as they are, since
# resolving symlinks between store paths would refer to their targets
# instead (see issue #454199).  The result is stored in resolvedPath.
# Fails if there are too many symlinks.
resolveLibDir() {
    local rest="$1/" component link target links=0
    # The common case: a path in the store with no `.`, `..` or empty
    # components is already resolved, since it has no symlink to follow.
    if [[ "$1" == "${NIX_STORE:-}"/* && "$1/" != */./* && "$1/" != */../* && "$1/" != *//* ]]; then
        resolvedPath="$1"
        return
    fi
    if [[ "$rest" != /* ]]; then
        rest="$PWD/$rest"
    fi
    resolvedPath=
    while [[ -n "$rest" ]]; do
        component="${rest%%/*}"
        rest="${rest#*/}"
        case "$component" in
            "" | .) continue ;;
            ..)
                if [[ -L "$resolvedPath" ]]; then
                    # Follow it, then apply this `..` to its target.
                    link="$resolvedPath"
                    resolvedPath="${resolvedPath%/*}"
                    rest="../$rest"
                else
                    resolvedPath="${resolvedPath%/*}"
                    continue
                fi
                ;;
            *)
                link="$resolvedPath/$component"
                # Keep a symlink in the store unless `..` follows it, and
                # never resolve the store or its ancestors, which may be
                # symlinks (NIX_IGNORE_SYMLINK_STORE).
                if [[ "$link" == "${NIX_STORE:-}"/* || "${NIX_STORE:-}/" == "$link"/* || ! -L "$link" ]]; then
                    resolvedPath="$link"
                    continue
                fi
                ;;
        esac
        (( ++links <= 40 )) || return 1
        target=$(readlink "$link") || return 1
        # A relative target is relative to the directory containing the
        # link, which is now resolvedPath.
        if [[ "$target" == /* ]]; then
            resolvedPath=
        fi
        rest="$target/$rest"
    done
    resolvedPath="${resolvedPath:-/}"
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
