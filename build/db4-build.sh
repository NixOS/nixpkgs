#! /bin/sh

export PATH=/bin:/usr/bin

top=`pwd`
tar xvfz $src || exit 1
cd db-*/build_unix || exit 1
../dist/configure --prefix=$top --enable-cxx --enable-compat185 || exit 1
make || exit 1
make install || exit 1
cd $top || exit 1
rm -rf db-* || exit 1
