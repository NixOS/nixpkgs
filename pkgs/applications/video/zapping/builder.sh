. $stdenv/setup

export PERL5LIB=$perlXMLParser/lib/site_perl:$PERL5LIB

# !!! hack
NIX_LDFLAGS="$NIX_LDFLAGS -rpath $libXext/lib"

# !!! hack - `make install' tries to setuid to root
installFlags="ZSFB_OWNER=`id -u` ZSFB_GROUP=`id -g`"

genericBuild
