#! /bin/sh

export PATH=/bin:/usr/bin

top=`pwd`
tar xvfz $src
cd pkgconfig-*
./configure --prefix=$top
make
make install
cd ..
rm -rf pkgconfig-*
