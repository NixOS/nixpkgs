#! /bin/sh

if test -n "$NIX_LD_WRAPPER_START_HOOK"; then
    . "$NIX_LD_WRAPPER_START_HOOK"
fi

extra=()

if test -z "$NIX_LDFLAGS_SET"; then
    extra=(${extra[@]} $NIX_LDFLAGS)
fi

if test "$NIX_DEBUG" = "1"; then
  echo "original flags to @ld@:" >&2
  for i in "$@"; do
      echo "  $i" >&2
  done
  echo "extra flags to @ld@:" >&2
  for i in ${extra[@]}; do
      echo "  $i" >&2
  done
fi

if test -n "$NIX_LD_WRAPPER_EXEC_HOOK"; then
    . "$NIX_LD_WRAPPER_EXEC_HOOK"
fi

exec @ld@ "$@" ${extra[@]}
