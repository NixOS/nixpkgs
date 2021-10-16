#! /usr/bin/env nix-shell
#! nix-shell -i bash -p coreutils findutils gnused nix wget

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

# use mirrorlist files to get sha256 sums
# patch WGET_ARGS from nixpkgs/pkgs/development/libraries/qt-6/6.2/fetch.sh etc
[ "${WGET_ARGS[-1]}" = '*.tar.xz' ] && WGET_ARGS[-1]='*.tar.xz.mirrorlist'

echo 'fetching mirrorlist files ...'
echo wget -nH -r -c --no-parent "${WGET_ARGS[@]}"
wget -nH -r -c --no-parent "${WGET_ARGS[@]}" >/dev/null

csv=$(mktemp)
find . -type f -name '*.mirrorlist' | while read mirrorlist; do
    src="${mirrorlist%.*}" # remove extension
    # Sanitize file name
    filename=$(basename "$src" | tr '@' '_')
    nameVersion="${filename%.tar.*}"
    name=$(echo "$nameVersion" | sed -e 's,-[[:digit:]].*,,' | sed -e 's,-opensource-src$,,' | sed -e 's,-everywhere-src$,,')
    version=$(echo "$nameVersion" | sed -e 's,^\([[:alpha:]][[:alnum:]]*-\)\+,,')
    echo "$name,$version,$src,$filename,$mirrorlist" >>$csv
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
    mirrorlist=$(gawk -F , "/^$name,$latestVersion,/ { print \$5 }" $csv)
    url="${src:2}"
    sha256=$(grep -F '>SHA-256 Hash<' "$mirrorlist" | sed -E 's|^.*<tt>([0-9a-f]{64})</tt>.*|\1|')
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
