#! /bin/sh

. $stdenv/setup || exit 1

tar xvfj $src || exit 1
cd binutils-* || exit 1

# Clear the default library search path.
echo 'NATIVE_LIB_DIRS=' >> ld/configure.tgt || exit 1

./configure --prefix=$out || exit 1
make || exit 1
make install || exit 1

strip -S $out/lib/*.a || exit 1
