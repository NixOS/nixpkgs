#! /bin/sh

IFS=

realgcc=@GCC@

justcompile=0
for i in $@; do
    if test "$i" == "-c"; then
        justcompile=1
    fi
    if test "$i" == "-S"; then
        justcompile=1
    fi
    if test "$i" == "-E"; then
        justcompile=1
    fi
done

IFS=" "
extra=($NIX_CFLAGS)
if test "$justcompile" != "1"; then
    extra=(${extra[@]} $NIX_LDFLAGS)
    if test "$NIX_STRIP_DEBUG" == "1"; then
	extra=(${extra[@]} -Wl,-s)
    fi
fi

if test "$NIX_DEBUG" == "1"; then
  echo "extra gcc flags:" >&2
  for i in ${extra[@]}; do
      echo "  $i" >&2
  done
fi

IFS=
exec $realgcc $@ ${extra[@]}
