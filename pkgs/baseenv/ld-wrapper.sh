#! /bin/sh

IFS=" "
extra=($NIX_CFLAGS_LINK $NIX_LDFLAGS)
if test "$NIX_STRIP_DEBUG" == "1"; then
    extra=(${extra[@]} -s)
fi

if test "$NIX_DEBUG" == "1"; then
  echo "extra flags to @LD@:" >&2
  for i in ${extra[@]}; do
      echo "  $i" >&2
  done
fi

IFS=
exec $NIX_LD $@ ${extra[@]}
