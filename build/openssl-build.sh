#! /bin/sh

export PATH=/bin:/usr/bin

top=`pwd`
tar xvfz $src || exit 1
cd openssl-* || exit 1
./config --prefix=$top || exit 1
make || exit 1
make install || exit 1
cd $top || exit 1
rm -rf openssl-* || exit 1
