#! /bin/sh

export PATH=/bin:/usr/bin

export LDFLAGS=-s

top=`pwd`
tar xvfz $src
cd subversion-*
./configure --prefix=$top --with-ssl
make
make install
cd ..
rm -rf subversion-*
