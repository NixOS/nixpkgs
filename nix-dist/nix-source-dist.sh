#! /bin/sh

buildinputs="$autoconf $automake $libxml2 $libxslt"
. $stdenv/setup

echo "copying sources..."
cp -prd $src/* . || exit 1
chmod -R u+w . || exit 1
cp -p $bdbSrc externals/db-4.1.25.tar.gz || exit 1 # !!!
cp -p $atermSrc externals/aterm-2.0.5.tar.gz || exit 1
cp -p $sdfSrc externals/sdf2-bundle-1.6.tar.gz || exit 1

echo "autoconfing..."
autoreconf -i || exit 1

echo "configuring..."
./configure --prefix=`pwd`/inst \
 --with-docbook-catalog=$docbook_dtd/xml/dtd/docbook/docbook.cat \
 --with-docbook-xsl=$docbook_xslt/xml/xsl/docbook \
 --with-xml-flags="--nonet" || exit 1

echo "building..."
make distdir || exit 1
pkgname=$(echo nix-*)
tar cvfz $pkgname.tar.gz $pkgname || exit 1
tar cvfj $pkgname.tar.bz2 $pkgname || exit 1

echo "copying result..."
mkdir $out || exit 1
cp -p $pkgname.tar.gz $pkgname.tar.bz2 $out || exit 1
(cd doc/manual && make install) || exit 1
(cd inst/share/nix && tar cvfj $out/manual.tar.bz2 manual) || exit 1
