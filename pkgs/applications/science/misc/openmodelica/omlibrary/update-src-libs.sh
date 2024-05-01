#! /usr/bin/env nix-shell
#! nix-shell -i bash -p bash jq busybox unzip

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
    nix build -f check.nix
    jq -s "[.[]|del(.mirrors)|.[].[].[].[].zipfile]|unique|.[]" result/libraries/index.json result/libraries/install-index.json
  )
}

getsha256() {
  SHA=$(nix-prefetch-url $1 --unpack 2>/dev/null)
  # This was the least annoying way I could come up with to recover the root folder name, since nix-prefetch-url has no stripRoot=false option
  foldername=$(curl -L $1 2>/dev/null | busybox unzip -qql - | sed -r '1 {s/([ ]+[^ ]+){3}\s+//;q}' | sed 's:/*$::')
  echo "{ url = \"$1\"; sha256 = \"$SHA\"; folderName = \"$foldername\"; stripRoot = true; }"
}

OUT=src-libs.nix

echo '[' > $OUT

chko |
tr -d '"' |
tail -n +2 |
while read URL ; do
  # read encases everything in single quotes, so this is safe
  echo Trying $URL >&2
  getsha256 $URL >> $OUT || exit 1
done

echo ']' >> $OUT
