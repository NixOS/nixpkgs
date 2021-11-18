#! /usr/bin/env nix-shell
#! nix-shell -i bash -p coreutils findutils gnused nix wget

set -efuo pipefail
export LC_COLLATE=C # fix sort order

# you can override this function in fetch.sh
function PARSE_INDEX() {
    cat "$1" | grep -o -E '\shref="[^"]+\.tar\.xz"' | cut -d'"' -f2 | sort | uniq
}

echo "$1" | grep '^pkgs/' >/dev/null || {
    echo "error: path argument must start with pkgs/"
    exit 1
}

basedirrel="$1"
basedir="$(readlink -f "$basedirrel")" # resolve absolute path
if ! [ -d "$basedir" ]; then
    basedir="$(dirname "$basedir")"
fi

pkgname=$(basename "$basedir")
fetchfile="$basedir/fetch.sh"
SRCS="$basedir/srcs.nix"
srcsrel="$basedirrel/srcs.nix"

# minimize diff. old hashes are base16
# TODO remove this in future
outputbase32=true
if (echo "$basedirrel" | grep -E '^pkgs/development/libraries/qt-5/5\.(14|15)/?$' >/dev/null)
then outputbase32=false; fi

. "$fetchfile"

echo "$BASE_URL" >/dev/null # throws 'unbound variable' when BASE_URL is not defined

tmptpl=tmp.fetch-kde-qt.$pkgname.XXXXXXXXXX

tmp=$(mktemp -d $tmptpl)
pushd $tmp >/dev/null
echo "tempdir is $tmp"

wgetargs='--quiet'

echo "fetching index.html from $BASE_URL"
wget $wgetargs -O 'index.html' "$BASE_URL"

echo 'parsing index.html'
filelist="$(PARSE_INDEX 'index.html')"
filecount=$(echo -n "$filelist" | wc -l)

if [ "$filecount" = '0' ]
then
    echo "error: no files parsed from $tmp/index.html"
    exit 1
fi

if false; then
# debug
echo "getting file sizes ..."
totalsize=0
while read file
do
    size=$(curl -I -L -s "$BASE_URL/$file" | grep -i Content-Length | cut -d' ' -f2 | tr -d '\r')
    printf "size %10i %s\n" "$size" "$file"
    totalsize=$(expr "$totalsize" + "$size")
done <<<"$filelist"
echo "total size: $totalsize byte"
fi

# most time is spent here
echo "fetching $filecount sha256 files ..."
urllist="$(echo "$filelist" | while read file; do echo "$BASE_URL/$file.sha256"; done)"
echo "$urllist" | xargs wget $wgetargs -nH -r -c --no-parent
# wget -r: keep directory structure

csv=$(mktemp $tmptpl.csv)
find . -type f -name '*.sha256' | while read sha256file; do
    src="${sha256file%.*}" # remove extension
    sha256=$(cat $sha256file | cut -d' ' -f1) # base16
    if $outputbase32; then
        sha256=$(nix-hash --type sha256 --to-base32 $sha256)
    fi
    # Sanitize file name
    filename=$(basename "$src" | tr '@' '_')
    nameVersion="${filename%.tar.*}"
    name=$(echo "$nameVersion" | sed -e 's,-[[:digit:]].*,,' | sed -e 's,-opensource-src$,,' | sed -e 's,-everywhere-src$,,')
    version=$(echo "$nameVersion" | sed -e 's,^\([[:alpha:]][[:alnum:]]*-\)\+,,')
    echo "$name,$version,$src,$filename,$sha256" >>$csv
done

echo "writing output"
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
    sha256=$(gawk -F , "/^$name,$latestVersion,/ { print \$5 }" $csv)
    url="${src:2}"
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

echo "compare:"
echo "git diff $srcsrel"

popd >/dev/null
rm -fr $tmp >/dev/null

rm -f $csv >/dev/null
