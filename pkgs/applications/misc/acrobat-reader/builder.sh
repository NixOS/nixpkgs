. $stdenv/setup

echo "unpacking $src..."
tar xvfz $src

mkdir $out

echo "unpacking reader..."
tar xvf AdobeReader/COMMON.TAR -C $out
tar xvf AdobeReader/ILINXR.TAR -C $out

# Disable this plugin for now (it needs LDAP, and I'm too lazy to add it).
rm $out/Reader/intellinux/plug_ins/PPKLite.api

glibc=$(cat $NIX_GCC/nix-support/orig-glibc)

patchelf --interpreter $glibc/lib/ld-linux.so.* $out/Reader/intellinux/bin/acroread

fullPath=
for i in $libPath; do
    fullPath=$fullPath${fullPath:+:}$i/lib
done

echo "#! $SHELL" > $out/bin/acroread.tmp
echo "LD_LIBRARY_PATH=$fullPath\${LD_LIBRARY_PATH:+:}\$LD_LIBRARY_PATH" >> $out/bin/acroread.tmp
cat $out/bin/acroread >> $out/bin/acroread.tmp
chmod 755 $out/bin/acroread.tmp
mv $out/bin/acroread.tmp $out/bin/acroread
