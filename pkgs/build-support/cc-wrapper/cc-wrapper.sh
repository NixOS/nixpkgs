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
linkType=$(checkLinkType "${params[@]}")

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
        -x)
            case "$p2" in
                *-header) dontLink=1 ;;
                c++*) isCxx=1 ;;
            esac
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

        if [[ -n $path ]] && badPath "$path"; then
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
            skip "$p"
        else
            kept+=("$p")
        fi
    done
    # Old bash empty array hack
    params=(${kept+"${kept[@]}"})
fi

if [[ "$isCxx" = 1 ]]; then
    if [[ "$cxxInclude" = 1 ]]; then
        NIX_CFLAGS_COMPILE_@suffixSalt@+=" $NIX_CXXSTDLIB_COMPILE_@suffixSalt@"
    fi
    if [[ "$cxxLibrary" = 1 ]]; then
        NIX_CFLAGS_LINK_@suffixSalt@+=" $NIX_CXXSTDLIB_LINK_@suffixSalt@"
    fi
fi

source @out@/nix-support/add-hardening.sh

# Add the flags for the C compiler proper.
extraAfter=($NIX_CFLAGS_COMPILE_@suffixSalt@)
extraBefore=(${hardeningCFlags[@]+"${hardeningCFlags[@]}"} $NIX_CFLAGS_COMPILE_BEFORE_@suffixSalt@)

if [ "$dontLink" != 1 ]; then

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

PATH="$path_backup"
# Old bash workaround, see above.

if (( "${NIX_CC_USE_RESPONSE_FILE:-@use_response_file_by_default@}" >= 1 )); then
    exec @prog@ @<(printf "%q\n" \
       ${extraBefore+"${extraBefore[@]}"} \
       ${params+"${params[@]}"} \
       ${extraAfter+"${extraAfter[@]}"})
else
    exec @prog@ \
       ${extraBefore+"${extraBefore[@]}"} \
       ${params+"${params[@]}"} \
       ${extraAfter+"${extraAfter[@]}"}
fi
