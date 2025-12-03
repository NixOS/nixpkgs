#! @shell@
set -eu -o pipefail +o posix
shopt -s nullglob

if (( "${NIX_DEBUG:-0}" >= 7 )); then
    set -x
fi

path_backup="$PATH"

# That @-vars are substituted separately from bash evaluation makes
# shellcheck think this, and others like it, are useless conditionals.
# shellcheck disable=SC2157
if [[ -n "@coreutils_bin@" && -n "@gnugrep_bin@" ]]; then
    PATH="@coreutils_bin@/bin:@gnugrep_bin@/bin"
fi

source @out@/nix-support/utils.bash

source @out@/nix-support/darwin-sdk-setup.bash


# Parse command line options and set several variables.
# For instance, figure out if linker flags should be passed.
# GCC prints annoying warnings when they are not needed.
dontLink=0
nonFlagArgs=0
cc1=0
# shellcheck disable=SC2193
[[ "@prog@" = *++ ]] && isCxx=1 || isCxx=0
cxxInclude=1
cxxLibrary=1
cInclude=1

expandResponseParams "$@"

declare -ag positionalArgs=()
declare -i n=0
nParams=${#params[@]}
while (( "$n" < "$nParams" )); do
    p=${params[n]}
    p2=${params[n+1]:-} # handle `p` being last one
    n+=1

    case "$p" in
        -[cSEM] | -MM) dontLink=1 ;;
        -cc1) cc1=1 ;;
        -nostdinc) cInclude=0 cxxInclude=0 ;;
        -nostdinc++) cxxInclude=0 ;;
        -nostdlib) cxxLibrary=0 ;;
        -x*-header) dontLink=1 ;; # both `-x c-header` and `-xc-header` are accepted by clang
        -xc++*) isCxx=1 ;;        # both `-xc++` and `-x c++` are accepted by clang
        -x)
            case "$p2" in
                *-header) dontLink=1 ;;
                c++*) isCxx=1 ;;
            esac
            ;;
        --) # Everything else is positional args!
            # See: https://github.com/llvm/llvm-project/commit/ed1d07282cc9d8e4c25d585e03e5c8a1b6f63a74

            # Any positional arg (i.e. any argument after `--`) will be
            # interpreted as a "non flag" arg:
            if [[ -v "params[$n]" ]]; then nonFlagArgs=1; fi

            positionalArgs=("${params[@]:$n}")
            params=("${params[@]:0:$((n - 1))}")
            break;
            ;;
        -?*) ;;
        *) nonFlagArgs=1 ;; # Includes a solitary dash (`-`) which signifies standard input; it is not a flag
    esac
done

# If we pass a flag like -Wl, then gcc will call the linker unless it
# can figure out that it has to do something else (e.g., because of a
# "-c" flag).  So if no non-flag arguments are given, don't pass any
# linker flags.  This catches cases like "gcc" (should just print
# "gcc: no input files") and "gcc -v" (should print the version).
if [ "$nonFlagArgs" = 0 ]; then
    dontLink=1
fi

# Arocc does not link
if [ "@isArocc@" = 1 ]; then
    dontLink=1
fi

# Optionally filter out paths not refering to the store.
if [[ "${NIX_ENFORCE_PURITY:-}" = 1 && -n "$NIX_STORE" ]]; then
    kept=()
    nParams=${#params[@]}
    declare -i n=0
    while (( "$n" < "$nParams" )); do
        p=${params[n]}
        p2=${params[n+1]:-} # handle `p` being last one
        n+=1

        skipNext=false
        path=""
        case "$p" in
            -[IL]/*) path=${p:2} ;;
            -[IL] | -isystem) path=$p2 skipNext=true ;;
        esac

        if [[ -n $path ]] && badPathWithDarwinSdk "$path"; then
            skip "$path"
            $skipNext && n+=1
            continue
        fi

        kept+=("$p")
    done
    # Old bash empty array hack
    params=(${kept+"${kept[@]}"})
fi

# Flirting with a layer violation here.
if [ -z "${NIX_BINTOOLS_WRAPPER_FLAGS_SET_@suffixSalt@:-}" ]; then
    source @bintools@/nix-support/add-flags.sh
fi

# Put this one second so libc ldflags take priority.
if [ -z "${NIX_CC_WRAPPER_FLAGS_SET_@suffixSalt@:-}" ]; then
    source @out@/nix-support/add-flags.sh
fi

# Clear march/mtune=native -- they bring impurity.
if [ "$NIX_ENFORCE_NO_NATIVE_@suffixSalt@" = 1 ]; then
    kept=()
    # Old bash empty array hack
    for p in ${params+"${params[@]}"}; do
        if [[ "$p" = -m*=native ]]; then
            >&2 echo "warning: Skipping impure flag $p because NIX_ENFORCE_NO_NATIVE is set"
        else
            kept+=("$p")
        fi
    done
    # Old bash empty array hack
    params=(${kept+"${kept[@]}"})
fi

# Some build systems such as Bazel and SwiftPM use `clang` instead of `clang++`,
# which will find the libc++ headers in the sysroot for C++ files.
if [[ "$isCxx" = 0 && "@isClang@" ]]; then
# This duplicates the behavior of a native toolchain, which can find the
# libc++ headers but requires `-lc++` to be specified explicitly when linking.
    isCxx=1
    cxxLibrary=0
fi

if [[ "$isCxx" = 1 ]]; then
    if [[ "$cxxInclude" = 1 ]]; then
        #
        # The motivation for this comment is to explain the reason for appending
        # the C++ stdlib to NIX_CFLAGS_COMPILE, which I initially thought should
        # change and later realized it shouldn't in:
        #
        #   https://github.com/NixOS/nixpkgs/pull/185569#issuecomment-1234959249
        #
        # NIX_CFLAGS_COMPILE contains dependencies added using "-isystem", and
        # NIX_CXXSTDLIB_COMPILE adds the C++ stdlib using "-isystem". Appending
        # NIX_CXXSTDLIB_COMPILE to NIX_CLAGS_COMPILE emulates this part of the
        # include lookup order from GCC/Clang:
        #
        # > 4. Directories specified with -isystem options are scanned in
        # >    left-to-right order.
        # > 5. Standard system directories are scanned.
        # > 6. Directories specified with -idirafter options are scanned
        # >    in left-to-right order.
        #
        # NIX_CXX_STDLIB_COMPILE acts as the "standard system directories" that
        # are otherwise missing from CC in nixpkgs, so should be added last.
        #
        # This means that the C standard library should never be present inside
        # NIX_CFLAGS_COMPILE, because it MUST come after the C++ stdlib. It is
        # added automatically by cc-wrapper later using "-idirafter".
        #
        NIX_CFLAGS_COMPILE_@suffixSalt@+=" $NIX_CXXSTDLIB_COMPILE_@suffixSalt@"
    fi
    if [[ "$cxxLibrary" = 1 ]]; then
        NIX_CFLAGS_LINK_@suffixSalt@+=" $NIX_CXXSTDLIB_LINK_@suffixSalt@"
    fi
fi

source @out@/nix-support/add-hardening.sh

# Add the flags for the C compiler proper.
extraAfter=(${hardeningCFlagsAfter[@]+"${hardeningCFlagsAfter[@]}"} $NIX_CFLAGS_COMPILE_@suffixSalt@)
extraBefore=(${hardeningCFlagsBefore[@]+"${hardeningCFlagsBefore[@]}"} $NIX_CFLAGS_COMPILE_BEFORE_@suffixSalt@)

if [ "$dontLink" != 1 ]; then
    linkType=$(checkLinkType $NIX_LDFLAGS_BEFORE_@suffixSalt@ "${params[@]}" ${NIX_CFLAGS_LINK_@suffixSalt@:-} $NIX_LDFLAGS_@suffixSalt@)

    # Add the flags that should only be passed to the compiler when
    # linking.
    extraAfter+=($(filterRpathFlags "$linkType" $NIX_CFLAGS_LINK_@suffixSalt@))

    # Add the flags that should be passed to the linker (and prevent
    # `ld-wrapper' from adding NIX_LDFLAGS_@suffixSalt@ again).
    for i in $(filterRpathFlags "$linkType" $NIX_LDFLAGS_BEFORE_@suffixSalt@); do
        extraBefore+=("-Wl,$i")
    done
    if [[ "$linkType" == dynamic && -n "$NIX_DYNAMIC_LINKER_@suffixSalt@" ]]; then
        extraBefore+=("-Wl,-dynamic-linker=$NIX_DYNAMIC_LINKER_@suffixSalt@")
    fi
    for i in $(filterRpathFlags "$linkType" $NIX_LDFLAGS_@suffixSalt@); do
        if [ "${i:0:3}" = -L/ ]; then
            extraAfter+=("$i")
        else
            extraAfter+=("-Wl,$i")
        fi
    done
    export NIX_LINK_TYPE_@suffixSalt@=$linkType
fi

if [[ -e @out@/nix-support/add-local-cc-cflags-before.sh ]]; then
    source @out@/nix-support/add-local-cc-cflags-before.sh
fi

# As a very special hack, if the arguments are just `-v', then don't
# add anything.  This is to prevent `gcc -v' (which normally prints
# out the version number and returns exit code 0) from printing out
# `No input files specified' and returning exit code 1.
if [ "$*" = -v ]; then
    extraAfter=()
    extraBefore=()
fi

# clang's -cc1 mode is not compatible with most options
# that we would pass. Rather than trying to pass only
# options that would work, let's just remove all of them.
if [ "$cc1" = 1 ]; then
  extraAfter=()
  extraBefore=()
fi

# Finally, if we got any positional args, append them to `extraAfter`
# now:
if [[ "${#positionalArgs[@]}" -gt 0 ]]; then
    extraAfter+=(-- "${positionalArgs[@]}")
fi

# if a cc-wrapper-hook exists, run it.
if [[ -e @out@/nix-support/cc-wrapper-hook ]]; then
    compiler=@prog@
    source @out@/nix-support/cc-wrapper-hook
fi

# Optionally print debug info.
if (( "${NIX_DEBUG:-0}" >= 1 )); then
    # Old bash workaround, see ld-wrapper for explanation.
    echo "extra flags before to @prog@:" >&2
    printf "  %q\n" ${extraBefore+"${extraBefore[@]}"}  >&2
    echo "original flags to @prog@:" >&2
    printf "  %q\n" ${params+"${params[@]}"} >&2
    echo "extra flags after to @prog@:" >&2
    printf "  %q\n" ${extraAfter+"${extraAfter[@]}"} >&2
fi

export PATH="$path_backup"
# Old bash workaround, see above.

if (( "${NIX_CC_USE_RESPONSE_FILE:-@use_response_file_by_default@}" >= 1 )); then
    responseFile=$(@mktemp@ "${TMPDIR:-/tmp}/cc-params.XXXXXX")
    trap '@rm@ -f -- "$responseFile"' EXIT
    printf "%q\n" \
       ${extraBefore+"${extraBefore[@]}"} \
       ${params+"${params[@]}"} \
       ${extraAfter+"${extraAfter[@]}"} > "$responseFile"
    @prog@ "@$responseFile"
else
    exec @prog@ \
       ${extraBefore+"${extraBefore[@]}"} \
       ${params+"${params[@]}"} \
       ${extraAfter+"${extraAfter[@]}"}
fi
