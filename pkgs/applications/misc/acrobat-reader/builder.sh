. $stdenv/setup

echo "unpacking $src..."
tar xvfz $src

mkdir $out

echo "unpacking reader..."
tar xvf ./COMMON.TAR -C $out
tar xvf ./LINUXRDR.TAR -C $out

glibc=$(cat $NIX_GCC/nix-support/orig-glibc)

patchelf --interpreter $glibc/lib/ld-linux.so.* $out/Reader/intellinux/bin/acroread

sed "s^REPLACE_ME^$out/Reader^" $out/bin/acroread.sh > $out/bin/acroread.sh.tmp
echo "#! /bin/sh" > $out/bin/acroread.sh
echo "LD_LIBRARY_PATH=$libXt/lib:$libXp/lib:$libXext/lib:$libX11/lib" >> $out/bin/acroread.sh
cat $out/bin/acroread.sh.tmp >> $out/bin/acroread.sh
chmod 755 $out/bin/acroread.sh
mv $out/bin/acroread.sh $out/bin/acroread
