#! /bin/sh

export PATH=/bin:/usr/bin

top=`pwd`
tar xvfz $src || exit 1
cd libxml2-* || exit 1
./configure --prefix=$top || exit 1
make || exit 1
make install || exit 1
cd .. || exit 1
rm -rf libxml2-* || exit 1
