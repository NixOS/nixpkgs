# A policy is an environment record in the private wrapper_ namespace. Select
# it once from caller inputs; render it separately for each delegated operation.
wrapperInput() {
    local input="${1}_@suffixSalt@" value="wrapper_$1"
    unset "$value"
    if [[ -v $input ]]; then printf -v "$value" %s "${!input}"; fi
}

# Render compiler flags without changing selected policy. The C++ headers follow
# dependency -isystem flags (see NixOS/nixpkgs#185569); libc defaults retain
# crt1 -> libc -> cc ordering (see NixOS/nixpkgs#158042).
# Keeping the suppressible component separate lets a delegated compiler honor
# its own -nostdinc without discarding an identical caller-provided option.
wrapperCompileFlags() {
    local cxxHeadersForCDriver=${1:-0}
    declare -g +x wrapperCFlags wrapperCFlagsLink
    wrapperCFlags=$wrapper_NIX_CFLAGS_COMPILE
    wrapperCFlagsLink=$wrapper_NIX_CFLAGS_LINK
    if [[ $cInclude == 1 ]]; then
        wrapperCFlags="$wrapper_CC_LIBC_FLAGS $wrapperCFlags"
    fi
    wrapperCFlags="$wrapper_CC_CRT_FLAGS $wrapperCFlags"
    if [[ $isCxx == 1 ]]; then
        wrapperCFlags+=" $wrapper_NIX_CXXSTDLIB_COMPILE"
        wrapperCFlagsLink+=" $wrapper_NIX_CXXSTDLIB_LINK"
    fi
    if [[ $cxxInclude == 1 ]]; then
        if [[ $isCxx == 1 || $cxxHeadersForCDriver == 1 ]]; then
            wrapperCFlags+=" $wrapper_CC_CXX_FLAGS"
        fi
    fi
    if [[ $isCxx == 1 && $cxxLibrary == 1 ]]; then
        wrapperCFlagsLink+=" $wrapper_CC_CXX_LINK_FLAGS"
    fi
}

# Render raw linker policy for a compiler driver. Keep genuine -L paths in
# the driver's search channel without promoting another option's operand.
# Observation and execution must use the same translation.
wrapperCompilerLinkerFlags() {
    local wrapperLinkerIsLLVM=$1
    shift
    local arg operand=0 options=1
    declare -ga +x wrapperLinkerFlags=()
    for arg in "$@"; do
        if [[ $options == 1 && $operand == 0 && $arg == -L/* ]]; then
            wrapperLinkerFlags+=("$arg")
        else
            wrapperLinkerFlags+=("-Wl,$arg")
        fi
        if [[ $operand == 1 ]]; then
            operand=0
        elif [[ $arg == -- ]]; then
            options=0
        elif [[ $options == 1 ]] && linkerOptionTakesOperand "$arg"; then
            operand=1
        fi
    done
}

wrapperClear() {
    local name
    for name in "${!wrapper_@}"; do unset "$name"; done
    unset NIX_WRAPPER_VERSION NIX_WRAPPER_OPERATION
}

wrapperImport() {
    if [[ ${NIX_WRAPPER_VERSION:-} != 2 || ${NIX_WRAPPER_OPERATION:-} != "$1" ]]; then
        echo "expected a prepared $1 invocation" >&2
        return 1
    fi
    # A hook's independent subprocess must not inherit this request. Export it
    # again only when explicitly delegating; absence and empty remain distinct.
    local name
    for name in "${!wrapper_@}"; do export -n "$name"; done
    unset NIX_WRAPPER_VERSION NIX_WRAPPER_OPERATION
}

# This is an exec, so response-file users that need cleanup call it in a
# subshell. Hooks run before this boundary and still see the caller flag inputs.
wrapperRun() {
    local operation=$1 name
    shift
    if [[ -n $operation ]]; then
        export NIX_WRAPPER_VERSION=2 NIX_WRAPPER_OPERATION=$operation
        for name in "${!wrapper_@}"; do export "$name"; done
    else
        wrapperClear
    fi
    exec "$@"
}

# Older LLVM tokenizers drop empty quoted arguments. Keep those invocations
# as direct argv, including when an empty argument came from a wrapper hook.
# An outer response file would also hide native response-quoting selectors
# from the initial scan. Decline separate forms without parsing their operands.
canWriteResponseFile() {
    local arg
    for arg in "$@"; do
        case "$arg" in
            ""|--rsp-quoting=*|-rsp-quoting=*|--rsp-quoting|-rsp-quoting|--driver-mode=cl) return 1 ;;
        esac
    done
}

# GNU response-file syntax, shared by GCC, Clang and GNU-compatible linkers.
# Prepared raw overrides must support this grammar when response files are used.
# Bash %q instead emits shell-only $'...' syntax for tabs and newlines.
writeResponseFile() {
    local arg
    for arg in "$@"; do
        arg=${arg//\\/\\\\}
        arg=${arg//\"/\\\"}
        printf '"%s"\n' "$arg"
    done
}

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

    wrapperInput "$var"
    local outputVar="wrapper_$var"
    declare -g "$outputVar"+=''
    # For each role we serve, we accumulate the input parameters into our own
    # private selected-policy variables.
    for suffix in "${role_suffixes[@]}"; do
        local inputVar="${var}${suffix}"
        if [ -v "$inputVar" ]; then
            declare -g "${outputVar}+=${!outputVar:+$sep}${!inputVar}"
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

    wrapperInput "$var"
    local outputVar="wrapper_$var"
    declare -gi "${outputVar}+=0"
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

    wrapperInput "$var"
    local outputVar="wrapper_$var"
    for suffix in "${role_suffixes[@]}"; do
        local inputVar="${var}${suffix}"
        if [ -v "$inputVar" ]; then
            if [ -v "$outputVar" ]; then
                if [ "${!outputVar}" != "${!inputVar}" ]; then
                    {
                        echo "Multiple conflicting values defined for ${var}_@suffixSalt@"
                        echo "Existing value is ${!outputVar}"
                        echo "Attempting to set to ${!inputVar} via $inputVar"
                    } >&2

                    exit 1
                fi
            else
                declare -g ${outputVar}="${!inputVar}"
            fi
        fi
    done
}

# Prepare a public variable for another projection of its original inputs.
# Preserve intervening value changes, including an empty or unset value.
restoreProjectedVar() {
    local variable=$1 prefix=${2:-NIX_WRAPPER_$1}
    local original="${prefix}_ORIGINAL" projected="${prefix}_PROJECTED"
    if [[ -v $projected && -v $variable && ${!variable} == "${!projected}" ]]; then
        if [[ -v $original ]]; then
            export "$variable=${!original}"
        else
            unset "$variable"
        fi
    fi
    if [[ -v $variable ]]; then
        export "$original=${!variable}"
    else
        unset "$original"
    fi
    unset "$projected"
}

# Publish a result after restoreProjectedVar saved the original input.
exportProjectedVar() {
    local variable=$1 value=$2 prefix=${3:-NIX_WRAPPER_$1}
    export "$variable=$value" "${prefix}_PROJECTED=$value"
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
        sdkPath=$wrapper_SDKROOT/$path
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

# Options whose following argument is data, even when it looks like a mode.
# GNU ld rewrites -library* as -l...; LLD accepts those long aliases instead.
# Neither treats -output as --output: it is the joined short option -o utput.
linkerOptionTakesOperand() {
    case "$1" in
        -library|-library-path|-format)
            case "${wrapperLinkerIsLLVM:-@bintools_isLLVM@}" in
                1|unknown) return 0 ;;
                *) return 1 ;;
            esac ;;
    esac
    case "$1" in
        -o|--output|-L|--library-path|-l|--library \
        |-m|--emulation|-emulation|-z|-T|--script|-script|-e|--entry|-entry \
        |-u|--undefined|-undefined|-y|--trace-symbol|-trace-symbol|-h|--soname|-soname \
        |-R|--just-symbols|-just-symbols|-rpath|--rpath|-rpath-link|--rpath-link \
        |-dynamic-linker|--dynamic-linker|-I \
        |-plugin|--plugin|-plugin-opt|--plugin-opt|-Map|--Map|-O \
        |--format|--oformat|-oformat|--defsym|-defsym \
        |--version-script|-version-script|--dynamic-list|-dynamic-list \
        |--retain-symbols-file|-retain-symbols-file|--exclude-libs|-exclude-libs \
        |--auxiliary|-auxiliary|-f|--filter|-filter|-F|--audit|-audit \
        |--depaudit|-depaudit|--section-start|-section-start|--sysroot|-sysroot \
        |--hash-style|-hash-style|--dependency-file|-dependency-file \
        |-a|-A|--architecture|-b|-c|--mri-script|-G|--gpsize|-gpsize \
        |-Y|-P|-assert|-init|--init|-fini|--fini|-dT|--default-script|-default-script \
        |--out-implib|-out-implib|--remap-inputs-file|-remap-inputs-file|--remap-inputs|-remap-inputs \
        |--require-defined|-require-defined|--error-handling-script|-error-handling-script \
        |--sort-section|-sort-section|--spare-dynamic-tags|-spare-dynamic-tags|--task-link|-task-link \
        |-Tbss|-Tdata|-Ttext|-Ttext-segment|-Trodata-segment|-Tldata-segment \
        |--unresolved-symbols|-unresolved-symbols|--version-exports-section|-version-exports-section \
        |--export-dynamic-symbol|--export-dynamic-symbol-list \
        |--wrap|-wrap|--ignore-unresolved-symbol|-ignore-unresolved-symbol \
        |--orphan-handling|-orphan-handling|--hash-size|-hash-size|--max-cache-size|-max-cache-size)
            return 0 ;;
        *) return 1 ;;
    esac
}

# Classify actual linker argv, after the compiler has expanded specs/configs.
checkLinkerLinkType() {
    local p value
    local flavor=${wrapperLinkerIsLLVM:-@bintools_isLLVM@}
    local -i pie=0 static=0 noLoader=0 library=0 dynamicInput=0
    local -a states=()
    while (( $# )); do
        p=$1; shift
        if [[ $flavor == 1 ]]; then
            case "$p" in
                -library|-library=*|-library-path|-library-path=*) p=-$p ;;
            esac
        fi
        # -Bstatic only controls subsequent library searches. A DSO already
        # selected earlier still needs a loader, even if the final mode is static.
        case "$p" in
            -l|--library)
                if (( !static )) && [[ ${1:-} != :*.a ]]; then dynamicInput=1; fi ;;
            --library=*)
                value=${p#*=}
                if (( !static )) && [[ $value != :*.a ]]; then dynamicInput=1; fi ;;
            -l?*)
                if (( !static )) && [[ $p != -l:*.a ]]; then dynamicInput=1; fi ;;
            *.so|*.so.*) if [[ $p != -* ]]; then dynamicInput=1; fi ;;
        esac
        if linkerOptionTakesOperand "$p" && [[ $p != -dynamic-linker && $p != --dynamic-linker && $p != -I ]]; then
            if (( $# )); then shift; fi
            continue
        fi
        case "$p" in
            --) break ;;
            -dynamic-linker|--dynamic-linker|-I)
                noLoader=0; if (( $# )); then shift; fi ;;
            -dynamic-linker=*|--dynamic-linker=*|-I?*) noLoader=0 ;;
            -no-dynamic-linker|--no-dynamic-linker) noLoader=1 ;;
            -pie|--pie|-pic-executable|--pic-executable) pie=1; library=0 ;;
            -no-pie|--no-pie|-no-pic-executable|--no-pic-executable) pie=0; library=0 ;;
            -shared|--shared|-Bshareable|-r|--relocatable|-i|-Ur) library=1; pie=0 ;;
            -static|--static|-Bstatic|-dn|-non_shared) static=1 ;;
            -Bdynamic|-dy|-call_shared) static=0 ;;
            -push-state|--push-state) states+=("$static") ;;
            -pop-state|--pop-state)
                if (( ${#states[@]} )); then static=${states[-1]}; unset 'states[-1]'; fi ;;
        esac
    done
    if (( library )); then echo shared
    elif (( pie && noLoader )); then echo static-pie
    elif (( static && !pie && !dynamicInput )); then echo static
    else echo dynamic
    fi
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

linkerJustSymbolsIsRpath() {
    # GNU ELF ld treats -R as --just-symbols for existing files and as
    # -rpath for directories (including paths that do not exist yet). LLD
    # always treats -R as RPATH, and its long options always import symbols.
    local flavor=${wrapperLinkerIsLLVM:-@bintools_isLLVM@}
    case "$flavor" in
        unknown) return 1 ;;
        1) [[ ${2:--R} == -R* ]]; return ;;
    esac
    [[ ! -e $1 || -d $1 ]]
}

# When building static-pie executables we cannot have rpath
# set. At least glibc requires rpath to be empty
filterRpathFlags() {
    local linkType=$1 i value
    local -a ret=()
    shift

    if [[ "$linkType" == "static-pie" ]]; then
        while [[ "$#" -gt 0 ]]; do
            i="$1"; shift 1
            case "$i" in
                --) ret+=("$i" "$@"); break ;;
                -rpath|--rpath) if (( $# )); then shift; fi ;;
                -rpath=*|--rpath=*) ;;
                -R|--just-symbols|-just-symbols)
                    if (( $# )); then
                        if ! linkerJustSymbolsIsRpath "$1" "$i"; then ret+=("$i" "$1"); fi
                        shift
                    else ret+=("$i")
                    fi ;;
                -R?*|--just-symbols=*|-just-symbols=*)
                    case "$i" in -R*) value=${i:2} ;; *) value=${i#*=} ;; esac
                    if ! linkerJustSymbolsIsRpath "$value" "$i"; then ret+=("$i"); fi ;;
                *)
                    ret+=("$i")
                    if linkerOptionTakesOperand "$i" && (( $# )); then
                        ret+=("$1"); shift
                    fi ;;
            esac
        done
    else
        ret=("$@")
    fi
    echo "${ret[@]}"
}
