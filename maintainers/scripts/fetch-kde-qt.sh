#! /usr/bin/env nix-shell
#! nix-shell -i bash -p coreutils findutils gnused nix wget
# shellcheck shell=bash

set -efuo pipefail

SRCS=
if [ -d "$1" ]; then
    SRCS="$(pwd)/$1/srcs.nix"
    . "$1/fetch.sh"
else
    SRCS="$(pwd)/$(dirname $1)/srcs.nix"
    . "$1"
fi

tmp=$(mktemp -d)
pushd $tmp >/dev/null
wget -nH -r -c --no-parent "${WGET_ARGS[@]}" >/dev/null

csv=$(mktemp)
find . -type f | while read src; do
    # Sanitize file name
    filename=$(basename "$src" | tr '@' '_')
    nameVersion="${filename%.tar.*}"
    name=$(echo "$nameVersion" | sed -e 's,-[[:digit:]].*,,' | sed -e 's,-opensource-src$,,' | sed -e 's,-everywhere-src$,,')
    version=$(echo "$nameVersion" | sed -e 's,^\([[:alpha:]][[:alnum:]]*-\)\+,,')
    echo "$name,$version,$src,$filename" >>$csv
done

cat >"$SRCS" <<EOF
# DO NOT EDIT! This file is generated automatically.
# Command: $0 $@
{ fetchurl, mirror }:

{
EOF

gawk -F , "{ print \$1 }" $csv | sort | uniq | while read name; do
    versions=$(gawk -F , "/^$name,/ { print \$2 }" $csv)
    latestVersion=$(echo "$versions" | sort -rV | head -n 1)
    src=$(gawk -F , "/^$name,$latestVersion,/ { print \$3 }" $csv)
    filename=$(gawk -F , "/^$name,$latestVersion,/ { print \$4 }" $csv)
    url="${src:2}"
    sha256=$(nix-hash --type sha256 --base32 --flat "$src")
    cat >>"$SRCS" <<EOF
  $name = {
    version = "$latestVersion";
    src = fetchurl {
      url = "\${mirror}/$url";
      sha256 = "$sha256";
      name = "$filename";
    };
  };
EOF
done

echo "}" >>"$SRCS"

popd >/dev/null
rm -fr $tmp >/dev/null

rm -f $csv >/dev/null
