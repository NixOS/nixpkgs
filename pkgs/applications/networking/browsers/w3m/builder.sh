source $stdenv/setup

configureFlags="--with-ssl=$openssl --with-gc=$boehmgc $configureFlags"

genericBuild
