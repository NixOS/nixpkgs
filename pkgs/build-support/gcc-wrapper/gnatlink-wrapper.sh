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

exec @gnatlinkProg@ ${extraBefore[@]} "$@" ${extraAfter[@]}
