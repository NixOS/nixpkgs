. $stdenv/setup

configureFlags="--with-ssl=$openssl $configureFlags"
#export CFLAGS="-I$ncurses/include/ncurses"

genericBuild
