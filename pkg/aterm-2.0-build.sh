#! /bin/sh

export PATH=$utils/bin
export LIBRARY_PATH=$glibc/lib
export CC=$gcc/bin/gcc
export CFLAGS="-isystem $glibc/include -isystem $kernel/include"

top=`pwd`
tar xvfz $src
cd aterm-2.0
./configure --prefix=$top
make
make install
