#! /bin/sh

export PATH=/bin:/usr/bin

mkdir $out || exit 1
mkdir $out/bin || exit 1

sed \
 -e s^@OUT\@^$out^g \
 < $setup > $out/setup || exit 1

gcc='$NIX_CC'

sed \
 -e s^@GCC\@^$gcc^g \
 < $gccwrapper > $out/bin/gcc || exit 1
chmod +x $out/bin/gcc || exit 1

ln -s gcc $out/bin/cc

gcc='$NIX_CXX'

sed \
 -e s^@GCC\@^$gcc^g \
 < $gccwrapper > $out/bin/g++ || exit 1
chmod +x $out/bin/g++ || exit 1

ln -s g++ $out/bin/c++
