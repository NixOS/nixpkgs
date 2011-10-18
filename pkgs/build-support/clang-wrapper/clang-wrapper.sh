#! @shell@ -e

if test -n "$NIX_CLANG_WRAPPER_START_HOOK"; then
    source "$NIX_CLANG_WRAPPER_START_HOOK"
fi

if test -z "$NIX_CLANG_WRAPPER_FLAGS_SET"; then
    source @out@/nix-support/add-flags.sh
fi

source @out@/nix-support/utils.sh


# Figure out if linker flags should be passed.  Clang prints annoying
# warnings when they are not needed. (does it really? Copied from gcc-wrapper)
dontLink=0
getVersion=0
nonFlagArgs=0

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
    elif test "$i" = "-x"; then
        # At least for the cases c-header or c++-header we should set dontLink.
        # I expect no one use -x other than making precompiled headers.
        dontLink=1
    elif test "${i:0:1}" != "-"; then
        nonFlagArgs=1
    elif test "$i" = "-m32"; then
        if test -e @out@/nix-support/dynamic-linker-m32; then
            NIX_LDFLAGS="$NIX_LDFLAGS -dynamic-linker $(cat @out@/nix-support/dynamic-linker-m32)"
        fi
    fi
done

# If we pass a flag like -Wl, then clang will call the linker unless it
# can figure out that it has to do something else (e.g., because of a
# "-c" flag).  So if no non-flag arguments are given, don't pass any
# linker flags.  This catches cases like "clang" (should just print
# "clang: no input files") and "clang -v" (should print the version).
if test "$nonFlagArgs" = "0"; then
    dontLink=1
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
extraAfter=($NIX_CFLAGS_COMPILE)
extraBefore=()

if test "$dontLink" != "1"; then

    # Add the flags that should only be passed to the compiler when
    # linking.
    extraAfter=(${extraAfter[@]} $NIX_CFLAGS_LINK)

    # Add the flags that should be passed to the linker (and prevent
    # `ld-wrapper' from adding NIX_LDFLAGS again).
    for i in $NIX_LDFLAGS_BEFORE; do
        extraBefore=(${extraBefore[@]} "-Wl,$i")
    done
    for i in $NIX_LDFLAGS; do
	if test "${i:0:3}" = "-L/"; then
	    extraAfter=(${extraAfter[@]} "$i")
	else
	    extraAfter=(${extraAfter[@]} "-Wl,$i")
	fi
    done
    export NIX_LDFLAGS_SET=1

    if test "$NIX_STRIP_DEBUG" = "1"; then
        # Add executable-stripping flags.
        extraAfter=(${extraAfter[@]} $NIX_CFLAGS_STRIP)
    fi
fi

# As a very special hack, if the arguments are just `-v', then don't
# add anything.  This is to prevent `clang -v' (which normally prints
# out the version number and returns exit code 0) from printing out
# `No input files specified' and returning exit code 1.
if test "$*" = "-v"; then
    extraAfter=()
    extraBefore=()
fi    

# Optionally print debug info.
if test "$NIX_DEBUG" = "1"; then
  echo "original flags to @clangProg@:" >&2
  for i in "${params[@]}"; do
      echo "  $i" >&2
  done
  echo "extraBefore flags to @clangProg@:" >&2
  for i in ${extraBefore[@]}; do
      echo "  $i" >&2
  done
  echo "extraAfter flags to @clangProg@:" >&2
  for i in ${extraAfter[@]}; do
      echo "  $i" >&2
  done
fi

if test -n "$NIX_CLANG_WRAPPER_EXEC_HOOK"; then
    source "$NIX_CLANG_WRAPPER_EXEC_HOOK"
fi


# Call the real `clang'.  Filter out warnings from stderr about unused
# `-B' flags, since they confuse some programs.  Deep bash magic to
# apply grep to stderr (by swapping stdin/stderr twice).
if test -z "$NIX_CLANG_NEEDS_GREP"; then
    @clangProg@ ${extraBefore[@]} "${params[@]}" ${extraAfter[@]}
else
    (@clangProg@ ${extraBefore[@]} "${params[@]}" ${extraAfter[@]} 3>&2 2>&1 1>&3- \
        | (grep -v 'file path prefix' || true); exit ${PIPESTATUS[0]}) 3>&2 2>&1 1>&3-
    exit $?
fi    
