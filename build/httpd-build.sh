#! /bin/sh

export PATH=/bin:/usr/bin

top=`pwd`
tar xvfz $src || exit 1
cd httpd-* || exit 1
./configure --prefix=$top --enable-ssl --with-ssl=$ssl --enable-mods-shared=all || exit 1
make || exit 1
make install || exit 1
cd $top || exit 1
rm -rf httpd-* || exit 1
