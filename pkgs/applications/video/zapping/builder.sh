. $stdenv/setup

# !!! hack - `make install' tries to setuid to root
installFlags="ZSFB_OWNER=`id -u` ZSFB_GROUP=`id -g`"

genericBuild
