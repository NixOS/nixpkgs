#! /usr/bin/env nix-shell
#! nix-shell -i bash -p coreutils findutils gnused nix wget

set -efuo pipefail
export LC_COLLATE=C # fix sort order

# parse files and folders from https://download.kde.org/ and https://download.qt.io/
# you can override this function in fetch.sh
function PARSE_INDEX() {
    cat "$1" | grep -o -E -e '\s+href="[^"]+\.tar\.xz"' -e '\s+href="[-_a-zA-Z0-9]+/"' | cut -d'"' -f2 | sort | uniq
}

if [ $# != 1 ]; then
    echo "example use:" >&2
    echo "cd nixpkgs/" >&2
    echo "./maintainers/scripts/fetch-kde-qt.sh pkgs/development/libraries/qt-5/5.12" >&2
    exit 1
fi

if ! echo "$1" | grep -q '^pkgs/'; then
    echo "error: path argument must start with pkgs/" >&2
    exit 1
fi

# need absolute path for the pushd-popd block
if [ -f "$1" ]; then
    echo "ok: using fetchfile $1"
    fetchfilerel="$1"
    fetchfile="$(readlink -f "$fetchfilerel")" # resolve absolute path
    basedir="$(dirname "$fetchfile")"
    basedirrel="$(dirname "$fetchfilerel")"
elif [ -d "$1" ]; then
    echo "ok: using basedir $1"
    basedirrel="$1"
    basedir="$(readlink -f "$basedirrel")" # resolve absolute path
    if ! [ -d "$basedir" ]; then
        basedir="$(dirname "$basedir")"
    fi
    fetchfile="$basedir/fetch.sh"
else
    echo 'error: $1 must be file or dir' >&2
    exit 1
fi

pkgname=$(basename "$basedir")
SRCS="$basedir/srcs.nix"
srcsrel="$basedirrel/srcs.nix"

source "$fetchfile"

if [ -n "$WGET_ARGS" ]; then # old format
    BASE_URL="${WGET_ARGS[0]}" # convert to new format
    # validate
    if ! echo "$BASE_URL" | grep -q -E '^(http|https|ftp)://'; then
        printf 'error: from WGET_ARGS, converted invalid BASE_URL: %q\n' "$BASE_URL" >&2
        exit 1
    fi
    printf 'ok: from WGET_ARGS, converted BASE_URL: %q\n' "$BASE_URL"
elif [ -n "$BASE_URL" ]; then # new format
    :
else
    echo "error: fetch.sh must set either WGET_ARGS or BASE_URL" >&2
    exit 1
fi

tmptpl=tmp.fetch-kde-qt.$pkgname.XXXXXXXXXX

tmp=$(mktemp -d $tmptpl)
pushd $tmp >/dev/null
echo "tempdir is $tmp"

wgetargs='--quiet --show-progress'
#wgetargs='' # debug

dirlist="$BASE_URL"
filelist=""
base_url_len=${#BASE_URL}

clean_urls() {
    # // -> /
    sed -E 's,//+,/,g' | sed -E 's,^(http|https|ftp):/,&/,'
}

while [ -n "$dirlist" ]
do
    for dirurl in $dirlist
    do
        echo "fetching index.html from $dirurl"
        relpath=$(echo "./${dirurl:$base_url_len}" | clean_urls)
        mkdir -p "$relpath"
        indexfile=$(echo "$relpath/index.html" | clean_urls)
        wget $wgetargs -O "$indexfile" "$dirurl"
        echo "parsing $indexfile"
        filedirlist="$(PARSE_INDEX "$indexfile")"
        filelist_next="$(echo "$filedirlist" | grep '\.tar\.xz$' | while read file; do echo "$dirurl/$file"; done)"
        filelist_next="$(echo "$filelist_next" | clean_urls)"
        [ -n "$filelist" ] && filelist+=$'\n'
        filelist+="$filelist_next"
        dirlist="$(echo "$filedirlist" | grep -v '\.tar\.xz$' | while read dir; do echo "$dirurl/$dir"; done || true)"
        dirlist="$(echo "$dirlist" | clean_urls)"
    done
done

filecount=$(echo "$filelist" | wc -l)

if [ -z "$filelist" ]
then
    echo "error: no files parsed from $tmp/index.html"
    exit 1
fi

echo "parsed $filecount tar.xz files:"; echo "$filelist"

# most time is spent here
echo "fetching $filecount sha256 files ..."
urllist="$(echo "$filelist" | while read file; do echo "$file.sha256"; done)"
# wget -r: keep directory structure
echo "$urllist" | xargs wget $wgetargs -nH -r -c --no-parent && {
    actual=$(find . -type f -name '*.sha256' | wc -l)
    echo "fetching $filecount sha256 files done: got $actual files"
} || {
    # workaround: in rare cases, the server does not provide the sha256 files
    # for example when the release is just a few hours old
    # and the servers are not yet fully synced
    actual=$(find . -type f -name '*.sha256' | wc -l)
    echo "fetching $filecount sha256 files failed: got only $actual files"

    # TODO fetch only missing tar.xz files
    echo "fetching $filecount tar.xz files ..."
    echo "$filelist" | xargs wget $wgetargs -nH -r -c --no-parent

    echo "generating sha256 files ..."
    find . -type f -name '*.tar.xz' | while read src; do
        name=$(basename "$src")
        sha256=$(sha256sum "$src" | cut -d' ' -f1)
        echo "$sha256  $name" >"$src.sha256"
    done
}

csv=$(mktemp $tmptpl.csv)
echo "writing temporary file $csv ..."
find . -type f -name '*.sha256' | while read sha256file; do
    src="${sha256file%.*}" # remove extension
    sha256=$(cat $sha256file | cut -d' ' -f1) # base16
    sha256=$(nix-hash --type sha256 --to-base32 $sha256)
    # Sanitize file name
    filename=$(basename "$src" | tr '@' '_')
    nameVersion="${filename%.tar.*}"
    name=$(echo "$nameVersion" | sed -e 's,-[[:digit:]].*,,' | sed -e 's,-opensource-src$,,' | sed -e 's,-everywhere-src$,,')
    version=$(echo "$nameVersion" | sed -e 's,^\([[:alpha:]][[:alnum:]]*-\)\+,,')
    echo "$name,$version,$src,$filename,$sha256" >>$csv
done

files_before=$(grep -c 'src = ' "$SRCS")

echo "writing output file $SRCS ..."
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

files_after=$(grep -c 'src = ' "$SRCS")
echo "files before: $files_before"
echo "files after:  $files_after"

echo "compare:"
echo "git diff $srcsrel"

popd >/dev/null
rm -fr $tmp >/dev/null

rm -f $csv >/dev/null
