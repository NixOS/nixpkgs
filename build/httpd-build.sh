#! /bin/sh

export PATH=/bin:/usr/bin
export LD_LIBRARY_PATH=$ssl/lib:

top=`pwd`
tar xvfz $src || exit 1
cd httpd-* || exit 1
./configure --prefix=$top --enable-ssl --with-ssl=$ssl --with-berkeley-db=$db4 --enable-mods-shared=all || exit 1
make || exit 1
make install || exit 1
cd $top || exit 1
rm -rf httpd-* || exit 1
