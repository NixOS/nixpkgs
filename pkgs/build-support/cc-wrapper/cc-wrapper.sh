#! @shell@
set -e -o pipefail
shopt -s nullglob

path_backup="$PATH"

# That @-vars are substituted separately from bash evaluation makes
# shellcheck think this, and others like it, are useless conditionals.
# shellcheck disable=SC2157
if [[ -n "@coreutils_bin@" && -n "@gnugrep_bin@" ]]; then
    PATH="@coreutils_bin@/bin:@gnugrep_bin@/bin"
fi

if [ -n "$NIX_CC_WRAPPER_@infixSalt@_START_HOOK" ]; then
    source "$NIX_CC_WRAPPER_@infixSalt@_START_HOOK"
fi

if [ -z "$NIX_CC_WRAPPER_@infixSalt@_FLAGS_SET" ]; then
    source @out@/nix-support/add-flags.sh
fi

source @out@/nix-support/utils.sh


# Parse command line options and set several variables.
# For instance, figure out if linker flags should be passed.
# GCC prints annoying warnings when they are not needed.
dontLink=0
nonFlagArgs=0
# shellcheck disable=SC2193
[[ "@prog@" = *++ ]] && isCpp=1 || isCpp=0
cppInclude=1

expandResponseParams "$@"
declare -i n=0
nParams=${#params[@]}
while [ "$n" -lt "$nParams" ]; do
    p=${params[n]}
    p2=${params[n+1]}
    if [ "$p" = -c ]; then
        dontLink=1
    elif [ "$p" = -S ]; then
        dontLink=1
    elif [ "$p" = -E ]; then
        dontLink=1
    elif [ "$p" = -E ]; then
        dontLink=1
    elif [ "$p" = -M ]; then
        dontLink=1
    elif [ "$p" = -MM ]; then
        dontLink=1
    elif [[ "$p" = -x && "$p2" = *-header ]]; then
        dontLink=1
    elif [[ "$p" = -x && "$p2" = c++* && "$isCpp" = 0 ]]; then
        isCpp=1
    elif [ "$p" = -nostdlib ]; then
        isCpp=-1
    elif [ "$p" = -nostdinc ]; then
        cppInclude=0
    elif [ "$p" = -nostdinc++ ]; then
        cppInclude=0
    elif [ "${p:0:1}" != - ]; then
        nonFlagArgs=1
    elif [ "$p" = -m32 ]; then
        if [ -e @out@/nix-support/dynamic-linker-m32 ]; then
            NIX_@infixSalt@_LDFLAGS+=" -dynamic-linker $(< @out@/nix-support/dynamic-linker-m32)"
        fi
    fi
    n+=1
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
if [[ "$NIX_ENFORCE_PURITY" = 1 && -n "$NIX_STORE" ]]; then
    rest=()
    nParams=${#params[@]}
    declare -i n=0
    while [ "$n" -lt "$nParams" ]; do
        p=${params[n]}
        p2=${params[n+1]}
        if [ "${p:0:3}" = -L/ ] && badPath "${p:2}"; then
            skip "${p:2}"
        elif [ "$p" = -L ] && badPath "$p2"; then
            n+=1; skip "$p2"
        elif [ "${p:0:3}" = -I/ ] && badPath "${p:2}"; then
            skip "${p:2}"
        elif [ "$p" = -I ] && badPath "$p2"; then
            n+=1; skip "$p2"
        elif [ "$p" = -isystem ] && badPath "$p2"; then
            n+=1; skip "$p2"
        else
            rest+=("$p")
        fi
        n+=1
    done
    params=("${rest[@]}")
fi


# Clear march/mtune=native -- they bring impurity.
if [ "$NIX_@infixSalt@_ENFORCE_NO_NATIVE" = 1 ]; then
    rest=()
    for p in "${params[@]}"; do
        if [[ "$p" = -m*=native ]]; then
            skip "$p"
        else
            rest+=("$p")
        fi
    done
    params=("${rest[@]}")
fi

if [[ "$isCpp" = 1 ]]; then
    if [[ "$cppInclude" = 1 ]]; then
        NIX_@infixSalt@_CFLAGS_COMPILE+=" ${NIX_@infixSalt@_CXXSTDLIB_COMPILE-@default_cxx_stdlib_compile@}"
    fi
    NIX_@infixSalt@_CFLAGS_LINK+=" $NIX_@infixSalt@_CXXSTDLIB_LINK"
fi

source @out@/nix-support/add-hardening.sh

# Add the flags for the C compiler proper.
extraAfter=($NIX_@infixSalt@_CFLAGS_COMPILE "${hardeningCFlags[@]}")
extraBefore=()

if [ "$dontLink" != 1 ]; then

    # Add the flags that should only be passed to the compiler when
    # linking.
    extraAfter+=($NIX_@infixSalt@_CFLAGS_LINK "${hardeningLDFlags[@]}")

    # Add the flags that should be passed to the linker (and prevent
    # `ld-wrapper' from adding NIX_@infixSalt@_LDFLAGS again).
    for i in $NIX_@infixSalt@_LDFLAGS_BEFORE; do
        extraBefore+=("-Wl,$i")
    done
    for i in $NIX_@infixSalt@_LDFLAGS; do
        if [ "${i:0:3}" = -L/ ]; then
            extraAfter+=("$i")
        else
            extraAfter+=("-Wl,$i")
        fi
    done
    export NIX_@infixSalt@_LDFLAGS_SET=1
fi

# As a very special hack, if the arguments are just `-v', then don't
# add anything.  This is to prevent `gcc -v' (which normally prints
# out the version number and returns exit code 0) from printing out
# `No input files specified' and returning exit code 1.
if [ "$*" = -v ]; then
    extraAfter=()
    extraBefore=()
fi

# Optionally print debug info.
if [ -n "$NIX_DEBUG" ]; then
    echo "extra flags before to @prog@:" >&2
    printf "  %q\n" "${extraBefore[@]}"  >&2
    echo "original flags to @prog@:" >&2
    printf "  %q\n" "${params[@]}" >&2
    echo "extra flags after to @prog@:" >&2
    printf "  %q\n" "${extraAfter[@]}" >&2
fi

if [ -n "$NIX_CC_WRAPPER_@infixSalt@_EXEC_HOOK" ]; then
    source "$NIX_CC_WRAPPER_@infixSalt@_EXEC_HOOK"
fi

PATH="$path_backup"
exec @prog@ "${extraBefore[@]}" "${params[@]}" "${extraAfter[@]}"
