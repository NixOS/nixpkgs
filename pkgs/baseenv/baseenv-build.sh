#! /bin/sh

export PATH=/bin:/usr/bin

mkdir $out || exit 1
mkdir $out/bin || exit 1

sed \
 -e s^@OUT\@^$out^g \
 < $setup > $out/setup || exit 1

sed \
 -e 's^@GCC\@^$NIX_CC^g' \
 < $gccwrapper > $out/bin/gcc || exit 1
chmod +x $out/bin/gcc || exit 1
ln -s gcc $out/bin/cc || exit 1

sed \
 -e 's^@GCC\@^$NIX_CXX^g' \
 < $gccwrapper > $out/bin/g++ || exit 1
chmod +x $out/bin/g++ || exit 1
ln -s g++ $out/bin/c++ || exit 1

cp $ldwrapper $out/bin/ld || exit 1
chmod +x $out/bin/ld || exit 1
