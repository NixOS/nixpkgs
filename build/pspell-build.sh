#! /bin/sh

export PATH=/bin:/usr/bin

top=`pwd`
tar xvfz $src
cd pspell-*
./configure --prefix=$top
make
make install
