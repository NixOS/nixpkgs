. $stdenv/setup

export CFLAGS="$CFLAGS -I$ncurses/include/ncurses"
genericBuild
