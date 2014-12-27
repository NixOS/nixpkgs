#! @shell@ -e

# Add the flags for the GNAT compiler proper.
extraAfter="--GCC=@out@/bin/gcc"
extraBefore=()

# Add the flags that should be passed to the linker (and prevent
# `ld-wrapper' from adding NIX_LDFLAGS again).
#for i in $NIX_LDFLAGS_BEFORE; do
#    extraBefore=(${extraBefore[@]} "-largs $i")
#done

# Optionally print debug info.
if test "$NIX_DEBUG" = "1"; then
  echo "original flags to @gnatlinkProg@:" >&2
  for i in "$@"; do
      echo "  $i" >&2
  done
  echo "extraBefore flags to @gnatlinkProg@:" >&2
  for i in ${extraBefore[@]}; do
      echo "  $i" >&2
  done
  echo "extraAfter flags to @gnatlinkProg@:" >&2
  for i in ${extraAfter[@]}; do
      echo "  $i" >&2
  done
fi

if test -n "$NIX_GNAT_WRAPPER_EXEC_HOOK"; then
    source "$NIX_GNAT_WRAPPER_EXEC_HOOK"
fi


# Call the real `gcc'.  Filter out warnings from stderr about unused
# `-B' flags, since they confuse some programs.  Deep bash magic to
# apply grep to stderr (by swapping stdin/stderr twice).
if test -z "$NIX_GNAT_NEEDS_GREP"; then
    @gnatlinkProg@ ${extraBefore[@]} "$@" ${extraAfter[@]}
else
    (@gnatlinkProg@ ${extraBefore[@]} "$@" ${extraAfter[@]} 3>&2 2>&1 1>&3- \
        | (grep -v 'file path prefix' || true); exit ${PIPESTATUS[0]}) 3>&2 2>&1 1>&3-
    exit $?
fi
