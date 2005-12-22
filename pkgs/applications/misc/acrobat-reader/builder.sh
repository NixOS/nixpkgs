source $stdenv/setup

echo "unpacking $src..."
tar xvfz $src

mkdir $out

echo "unpacking reader..."
tar xvf AdobeReader/COMMON.TAR -C $out
tar xvf AdobeReader/ILINXR.TAR -C $out

# Disable this plugin for now (it needs LDAP, and I'm too lazy to add it).
rm $out/Reader/intellinux/plug_ins/PPKLite.api

if test -n "$fastStart"; then
    rm $out/Reader/intellinux/plug_ins/*.api
fi

glibc=$(cat $NIX_GCC/nix-support/orig-glibc)

fullPath=
for i in $libPath; do
    fullPath=$fullPath${fullPath:+:}$i/lib
done

patchelf --interpreter $glibc/lib/ld-linux.so.* \
    --set-rpath $fullPath \
    $out/Reader/intellinux/bin/acroread
