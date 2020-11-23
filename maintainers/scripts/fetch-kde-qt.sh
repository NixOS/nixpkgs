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
wget -nH -r -c --no-parent "${WGET_ARGS[@]}" -A '*.tar.xz.sig' -A '*.tar.xz.mirrorlist' -A '*.tar.xz.sha256' >/dev/null
# for KDE:
#  > wget will just find *.sig files - we'll fetch *.mirrorlist files manually and extract sha256 sums from the content
# for QT:
#  > wget will "traverse" *.mirrorlist files to find *.sha256 files
# Keep *.sig files and *.sha256 files only

# Delete *.mirrorlist (they were only needed to find *.sha256 files)
find -type f -name '*.mirrorlist' -delete

# we need the host to properly construct urls for 'manual' mirrorlist fetching for kde
host=$(echo ${WGET_ARGS[@]} | cut -d/ -f1-3)

csv=$(mktemp)
# KDE sig files
find . -type f -name '*.sig' | while read src; do
    filename="${src##*/}"
    filename="${filename%.sig}"
    path=$(dirname ${src:2})
    mirrorlistFile="${filename}.mirrorlist"
    wget -c "${host}/${path}/${mirrorlistFile}"
    # "parsing" html - this seems wrong, but could not find sha256 sums anywhere else for kde archives
    sha256=$(gawk -F "</*tr>|</*td>|<td style=\"[^\"]*\">" "/SHA256/ { print \$5 }" $mirrorlistFile)
    nameVersion="${filename%.tar.*}"
    name=$(echo "$nameVersion" | sed -e 's,-[[:digit:]].*,,' | sed -e 's,-opensource-src$,,' | sed -e 's,-everywhere-src$,,')
    version=$(echo "$nameVersion" | sed -e 's,^\([[:alpha:]][[:alnum:]]*-\)\+,,')
    echo "$name,$version,$sha256,$filename,$path" >>$csv
done

# QT sha256 files
find . -type f -name '*.sha256' | while read src; do
    filename="${src##*/}"
    filename="${filename%.sha256}"
    sha256=$(gawk '{ print $1 }' "$src")
    nameVersion="${filename%.tar.*}"
    name=$(echo "$nameVersion" | sed -e 's,-[[:digit:]].*,,' | sed -e 's,-opensource-src$,,' | sed -e 's,-everywhere-src$,,')
    version=$(echo "$nameVersion" | sed -e 's,^\([[:alpha:]][[:alnum:]]*-\)\+,,')
    path=$(dirname ${src:2})
    echo "$name,$version,$sha256,$filename,$path" >>$csv
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
    sha256=$(gawk -F , "/^$name,$latestVersion,/ { print \$3 }" $csv)
    filename=$(gawk -F , "/^$name,$latestVersion,/ { print \$4 }" $csv)
    path=$(gawk -F , "/^$name,$latestVersion,/ { print \$5 }" $csv)
    url="$path/$filename"
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
