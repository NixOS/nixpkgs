#!/bin/sh

CWD=`pwd`

chko() { (
T=`mktemp -d`
trap "rm -rf $T" EXIT INT PIPE
cd $T
cat >check.nix <<EOF
with import <nixpkgs> {};
fetchgit `cat $CWD/src-main.nix`
EOF
nix-build check.nix
cat result/libraries/Makefile.libs
) }

getsha256() { (
T=`mktemp -d`
trap "rm -rf $T" EXIT INT PIPE
cd $T

L=`echo $2 | wc -c`
if expr $L '<' 10 >/dev/null; then
T=`echo $2 | sed 's@"\(.*\)"@"refs/tags/\1"@'`
cat >check.nix <<EOF
with import <nixpkgs> {};
fetchgit {
  url = $1;
  rev = $T;
  sha256 = "0000000000000000000000000000000000000000000000000000";
}
EOF
SHA=`nix-build check.nix 2>&1 | sed -n 's/.*instead has ‘\(.*\)’.*/\1/g p'`
echo "{ url = $1; rev = $T; sha256=\"$SHA\"; }"
else
cat >check.nix <<EOF
with import <nixpkgs> {};
fetchgit {
  url = $1;
  rev = $2;
  sha256 = "0000000000000000000000000000000000000000000000000000";
}
EOF
SHA=`nix-build check.nix 2>&1 | sed -n 's/.*instead has ‘\(.*\)’.*/\1/g p'`
echo "{ url = $1; rev = $2; sha256=\"$SHA\"; }"
fi

# nix-build check.nix
) }

OUT=src-libs-git.nix

echo '[' > $OUT

chko |
grep checkout-git.sh |
tr \' \" |
while read NM TGT URL BR REV ; do
  echo Trying $TGT $URL $REV >&2
  getsha256 $URL $REV >> $OUT || exit 1
done

echo ']' >> $OUT

