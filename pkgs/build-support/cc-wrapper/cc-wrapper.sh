#! @shell@ -e
path_backup="$PATH"
if [ -n "@coreutils_bin@" ]; then
  PATH="@coreutils_bin@/bin:@gnugrep_bin@/bin"
fi

if [ -n "$NIX_CC_WRAPPER_START_HOOK" ]; then
    source "$NIX_CC_WRAPPER_START_HOOK"
fi

if [ -z "$NIX_CC_WRAPPER_FLAGS_SET" ]; then
    source @out@/nix-support/add-flags.sh
fi

source @out@/nix-support/utils.sh


# Parse command line options and set several variables.
# For instance, figure out if linker flags should be passed.
# GCC prints annoying warnings when they are not needed.
dontLink=0
getVersion=0
nonFlagArgs=0
[[ "@prog@" = *++ ]] && isCpp=1 || isCpp=0

params=("$@")
n=0
while [ $n -lt ${#params[*]} ]; do
    p=${params[n]}
    p2=${params[$((n+1))]}
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
    elif [ "${p:0:1}" != - ]; then
        nonFlagArgs=1
    elif [ "$p" = -m32 ]; then
        if [ -e @out@/nix-support/dynamic-linker-m32 ]; then
            NIX_LDFLAGS="$NIX_LDFLAGS -dynamic-linker $(cat @out@/nix-support/dynamic-linker-m32)"
        fi
    fi
    n=$((n + 1))
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
if [ "$NIX_ENFORCE_PURITY" = 1 -a -n "$NIX_STORE" ]; then
    rest=()
    n=0
    while [ $n -lt ${#params[*]} ]; do
        p=${params[n]}
        p2=${params[$((n+1))]}
        if [ "${p:0:3}" = -L/ ] && badPath "${p:2}"; then
            skip $p
        elif [ "$p" = -L ] && badPath "$p2"; then
            n=$((n + 1)); skip $p2
        elif [ "${p:0:3}" = -I/ ] && badPath "${p:2}"; then
            skip $p
        elif [ "$p" = -I ] && badPath "$p2"; then
            n=$((n + 1)); skip $p2
        elif [ "$p" = -isystem ] && badPath "$p2"; then
            n=$((n + 1)); skip $p2
        else
            rest+=("$p")
        fi
        n=$((n + 1))
    done
    params=("${rest[@]}")
fi


# Clear march/mtune=native -- they bring impurity.
if [ "$NIX_ENFORCE_NO_NATIVE" = 1 ]; then
    rest=()
    for i in "${params[@]}"; do
        if [[ "$i" = -m*=native ]]; then
            skip $i
        else
            rest+=("$i")
        fi
    done
    params=("${rest[@]}")
fi

if [[ "$isCpp" = 1 ]]; then
    NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE ${NIX_CXXSTDLIB_COMPILE-@default_cxx_stdlib_compile@}"
    NIX_CFLAGS_LINK="$NIX_CFLAGS_LINK $NIX_CXXSTDLIB_LINK"
fi

LD=@ldPath@/ld
source @out@/nix-support/add-hardening.sh

# Add the flags for the C compiler proper.
extraAfter=($NIX_CFLAGS_COMPILE ${hardeningCFlags[@]})
extraBefore=()

if [ "$dontLink" != 1 ]; then

    # Add the flags that should only be passed to the compiler when
    # linking.
    extraAfter+=($NIX_CFLAGS_LINK ${hardeningLDFlags[@]})

    # Add the flags that should be passed to the linker (and prevent
    # `ld-wrapper' from adding NIX_LDFLAGS again).
    for i in $NIX_LDFLAGS_BEFORE; do
        extraBefore=(${extraBefore[@]} "-Wl,$i")
    done
    for i in $NIX_LDFLAGS; do
        if [ "${i:0:3}" = -L/ ]; then
            extraAfter+=("$i")
        else
            extraAfter+=("-Wl,$i")
        fi
    done
    export NIX_LDFLAGS_SET=1
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
  echo "original flags to @prog@:" >&2
  for i in "${params[@]}"; do
      echo "  $i" >&2
  done
  echo "extraBefore flags to @prog@:" >&2
  for i in ${extraBefore[@]}; do
      echo "  $i" >&2
  done
  echo "extraAfter flags to @prog@:" >&2
  for i in ${extraAfter[@]}; do
      echo "  $i" >&2
  done
fi

if [ -n "$NIX_CC_WRAPPER_EXEC_HOOK" ]; then
    source "$NIX_CC_WRAPPER_EXEC_HOOK"
fi

PATH="$path_backup"
exec @prog@ ${extraBefore[@]} "${params[@]}" "${extraAfter[@]}"
