#! /bin/sh

export PATH=/bin:/usr/bin:/usr/local/bin

top=`pwd`
tar xvfz $src || exit 1
cd SWIG-* || exit 1
./configure --prefix=$top || exit 1
gmake || exit 1
gmake install || exit 1
cd $top || exit 1
rm -rf SWIG-* || exit 1
