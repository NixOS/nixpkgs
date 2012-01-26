#!/bin/sh

VERSIONBASE=3.4.5

VERSION=3.4.5.2

if [ $# -gt 2 ]; then
  VERSIONBASE=$1
  VERSION=$2
fi

echo '{fetchurl} : ['

for a in artwork base bootstrap calc components extensions extras filters \
  help impress libs-core libs-extern libs-extern-sys libs-gui postprocess \
  translations ure writer sdk testing; do

  URL=http://download.documentfoundation.org/libreoffice/src/$VERSIONBASE/libreoffice-$a-$VERSION.tar.bz2

  echo '(fetchurl {'
  echo "  url = \"$URL\";"
  echo "  sha256 = \"`nix-prefetch-url $URL`\";"
  echo '})'
done

echo ']'
