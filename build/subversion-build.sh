#! /bin/sh

export PATH=/bin:/usr/bin

export LDFLAGS=-s

top=`pwd`
tar xvfz $src || exit 1
cd subversion-* || exit 1
./configure --prefix=$top --with-ssl || exit 1
make || exit 1
make install || exit 1
cd $top || exit 1
rm -rf subversion-* || exit 1
