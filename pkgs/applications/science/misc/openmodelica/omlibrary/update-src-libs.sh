#!/usr/bin/env nix-shell
#! nix-shell -i bash -p bash

CWD=$PWD

chko() {
  (
    T=`mktemp -d`
    trap "rm -rf $T" EXIT INT PIPE
    cd $T
    cat >check.nix <<EOF
with import <nixpkgs> {};
fetchgit `cat $CWD/../mkderivation/src-main.nix`
EOF
    nix-build check.nix
    cat result/libraries/Makefile.libs
  )
}

getsha256() {
  URL=$(echo "$1" | sed 's/^"\(.*\)"$/\1/')
  REV=$(echo "$2" | sed 's/^"\(.*\)"$/\1/')
  SHA=$(nix run nixpkgs.nix-prefetch-git -c nix-prefetch-git --fetch-submodules "$URL" "$REV" 2>/dev/null | sed -n 's/.*"sha256": "\(.*\)",/\1/g p')
  echo "{ url = $1; rev = $2; sha256 = \"$SHA\"; fetchSubmodules = true; }"
}

OUT=src-libs.nix

echo '[' > $OUT

chko |
grep checkout-git.sh |
tr \' \" |
while read NM TGT URL BR REV ; do
  echo Trying $TGT $URL $REV >&2
  getsha256 $URL $REV >> $OUT || exit 1
done

echo ']' >> $OUT
