#! /bin/sh

export PATH=$sys1/bin:$sys2/bin
export LIBRARY_PATH=$glibc/lib
export CC=$gcc/bin/gcc
export CFLAGS="-isystem $glibc/include -isystem $kernel/include"

top=`pwd`
tar xvfz $src
cd aterm-2.0
./configure --prefix=$top
make
make install
