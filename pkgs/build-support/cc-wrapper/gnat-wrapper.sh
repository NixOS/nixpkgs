#! @shell@
set -eu -o pipefail +o posix
shopt -s nullglob

if (( "${NIX_DEBUG:-0}" >= 7 )); then
    set -x
fi

path_backup="$PATH"

# That @-vars are substituted separately from bash evaluation makes
# "shellcheck" think this, and others like it, are useless conditionals.

# shellcheck disable=SC2157
if [[ -n "@coreutils_bin@" && -n "@gnugrep_bin@" ]]; then
    PATH="@coreutils_bin@/bin:@gnugrep_bin@/bin"
fi

source @out@/nix-support/utils.bash

# Parse command line options and set internal variables used here and
# in nearby supporting scripts to adjust the invocation of GCC to
# avoid warnings for unneeded flags.
cInclude=0


expandResponseParams "$@"
declare -i n=0
nParams=${#params[@]}


# Optionally filter out paths not refering to the store.
if [[ "${NIX_ENFORCE_PURITY:-}" = 1 && -n "$NIX_STORE" ]]; then
    rest=()
    nParams=${#params[@]}
    declare -i n=0
    while (( "$n" < "$nParams" )); do
        p=${params[n]}
        p2=${params[n+1]:-} # handle `p` being last one
        if [ "${p:0:3}" = -L/ ] && badPath "${p:2}"; then
            skip "${p:2}"
        elif [ "$p" = -L ] && badPath "$p2"; then
            n+=1; skip "$p2"
        elif [ "${p:0:3}" = -I/ ] && badPath "${p:2}"; then
            skip "${p:2}"
        elif [ "$p" = -I ] && badPath "$p2"; then
            n+=1; skip "$p2"
        elif [ "${p:0:4}" = -aI/ ] && badPath "${p:3}"; then
            skip "${p:3}"
        elif [ "$p" = -aI ] && badPath "$p2"; then
            n+=1; skip "$p2"
        elif [ "${p:0:4}" = -aO/ ] && badPath "${p:3}"; then
            skip "${p:3}"
        elif [ "$p" = -aO ] && badPath "$p2"; then
            n+=1; skip "$p2"
        elif [ "$p" = -isystem ] && badPath "$p2"; then
            n+=1; skip "$p2"
        else
            rest+=("$p")
        fi
        n+=1
    done
    # Old bash empty array hack
    params=(${rest+"${rest[@]}"})
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
if [ "${NIX_ENFORCE_NO_NATIVE_@suffixSalt@:-0}" = 1 ]; then
    rest=()
    # Old bash empty array hack
    for p in ${params+"${params[@]}"}; do
        if [[ "$p" = -m*=native ]]; then
            skip "$p"
        else
            rest+=("$p")
        fi
    done
    # Old bash empty array hack
    params=(${rest+"${rest[@]}"})
fi

toolname=$(basename "$0")
case $toolname in
    gnatmake)
        extraBefore=("--GNATBIND=@out@/bin/gnatbind"
                     "--GNATLINK=@out@/bin/gnatlink")
        # Explicit multi-word to array conversion
        # shellcheck disable=SC2206
        extraAfter=($NIX_GNATFLAGS_COMPILE_@suffixSalt@)
        ;;
    gnatbind)
        extraBefore=()
        # Explicit multi-word to array conversion
        # shellcheck disable=SC2206
        extraAfter=($NIX_GNATFLAGS_COMPILE_@suffixSalt@)
        ;;
    gnatlink)
        extraBefore=()
        extraAfter=("--GCC=@out@/bin/gcc")
        ;;
    *)
        extraBefore=()
        extraAfter=()
        ;;
esac

# As a very special hack, if the arguments are just `-v', then don't
# add anything.  This is to prevent `gcc -v' (which normally prints
# out the version number and returns exit code 0) from printing out
# `No input files specified' and returning exit code 1.
if [ "$*" = -v ]; then
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
exec @prog@ \
    ${extraBefore+"${extraBefore[@]}"} \
    ${params+"${params[@]}"} \
    ${extraAfter+"${extraAfter[@]}"}
