source $stdenv/setup

tar xvfz $src
cd truecrypt-*

cp $pkcs11h pkcs11.h
cp $pkcs11th pkcs11t.h
cp $pkcs11fh pkcs11f.h

make PKCS11_INC="`pwd`"

mkdir -p $out/bin
cp Main/truecrypt $out/bin
mkdir -p $out/share/$name
cp License.txt $out/share/$name/LICENSE
