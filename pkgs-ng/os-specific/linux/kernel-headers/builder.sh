#! /bin/sh

. $stdenv/setup || exit 1

tar xvfj $src || exit 1
cd linux-* || exit 1
make include/linux/version.h || exit 1
mkdir $out || exit 1
mkdir $out/include || exit 1
cp -prvd include/linux include/asm-i386 $out/include || exit 1
cd $out/include || exit 1
ln -s asm-i386 asm || exit 1
