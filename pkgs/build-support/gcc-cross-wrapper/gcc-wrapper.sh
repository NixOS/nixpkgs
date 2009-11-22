#! @shell@ -e

if test -n "$NIX_GCC_WRAPPER_START_HOOK"; then
    source "$NIX_GCC_WRAPPER_START_HOOK"
fi

if test -z "$NIX_CROSS_GLIBC_FLAGS_SET"; then
    source @out@/nix-support/add-flags
fi

source @out@/nix-support/utils


# Figure out if linker flags should be passed.  GCC prints annoying
# warnings when they are not needed.
dontLink=0
if test "$*" = "-v" -o -z "$*"; then
    dontLink=1
else
    for i in "$@"; do
        if test "$i" = "-c"; then
            dontLink=1
        elif test "$i" = "-S"; then
            dontLink=1
        elif test "$i" = "-E"; then
            dontLink=1
        elif test "$i" = "-E"; then
            dontLink=1
        elif test "$i" = "-M"; then
            dontLink=1
        elif test "$i" = "-MM"; then
            dontLink=1
        fi
    done
fi


# Optionally filter out paths not refering to the store.
params=("$@")
if test "$NIX_ENFORCE_PURITY" = "1" -a -n "$NIX_STORE"; then
    rest=()
    n=0
    while test $n -lt ${#params[*]}; do
        p=${params[n]}
        p2=${params[$((n+1))]}
        if test "${p:0:3}" = "-L/" && badPath "${p:2}"; then
            skip $p
        elif test "$p" = "-L" && badPath "$p2"; then
            n=$((n + 1)); skip $p2
        elif test "${p:0:3}" = "-I/" && badPath "${p:2}"; then
            skip $p
        elif test "$p" = "-I" && badPath "$p2"; then
            n=$((n + 1)); skip $p2
        elif test "$p" = "-isystem" && badPath "$p2"; then
            n=$((n + 1)); skip $p2
        else
            rest=("${rest[@]}" "$p")
        fi
        n=$((n + 1))
    done
    params=("${rest[@]}")
fi


# Add the flags for the C compiler proper.
extraAfter=($NIX_CROSS_CFLAGS_COMPILE)
extraBefore=()

if test "$dontLink" != "1"; then

    # Add the flags that should only be passed to the compiler when
    # linking.
    extraAfter=(${extraAfter[@]} $NIX_CROSS_CFLAGS_LINK)

    # Add the flags that should be passed to the linker (and prevent
    # `ld-wrapper' from adding NIX_CROSS_LDFLAGS again).
    for i in $NIX_CROSS_LDFLAGS_BEFORE; do
        extraBefore=(${extraBefore[@]} "-Wl,$i")
    done
    for i in $NIX_CROSS_LDFLAGS; do
	if test "${i:0:3}" = "-L/"; then
	    extraAfter=(${extraAfter[@]} "$i")
	else
	    extraAfter=(${extraAfter[@]} "-Wl,$i")
	fi
    done
    export NIX_CROSS_LDFLAGS_SET=1

    if test "$NIX_STRIP_DEBUG" = "1"; then
        # Add executable-stripping flags.
        extraAfter=(${extraAfter[@]} $NIX_CFLAGS_STRIP)
    fi
fi

# Optionally print debug info.
if test "$NIX_DEBUG" = "1"; then
  echo "original flags to @gccProg@:" >&2
  for i in "${params[@]}"; do
      echo "  $i" >&2
  done
  echo "extraBefore flags to @gccProg@:" >&2
  for i in ${extraBefore[@]}; do
      echo "  $i" >&2
  done
  echo "extraAfter flags to @gccProg@:" >&2
  for i in ${extraAfter[@]}; do
      echo "  $i" >&2
  done
fi

if test -n "$NIX_GCC_WRAPPER_EXEC_HOOK"; then
    source "$NIX_GCC_WRAPPER_EXEC_HOOK"
fi

# We want gcc to call the wrapper linker, not that of binutils.
export PATH="@ldPath@:$PATH"

# Call the real `gcc'.  Filter out warnings from stderr about unused
# `-B' flags, since they confuse some programs.  Deep bash magic to
# apply grep to stderr (by swapping stdin/stderr twice).
if test -z "$NIX_GCC_NEEDS_GREP"; then
    @gccProg@ ${extraBefore[@]} "${params[@]}" ${extraAfter[@]}
else
    (@gccProg@ ${extraBefore[@]} "${params[@]}" ${extraAfter[@]} 3>&2 2>&1 1>&3- \
        | (grep -v 'file path prefix' || true); exit ${PIPESTATUS[0]}) 3>&2 2>&1 1>&3-
    exit $?
fi    
