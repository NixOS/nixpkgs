#! /usr/bin/env bash

# https://talonvoice.com/
# https://github.com/talonvoice/talon

urlbase='https://talonvoice.com/dl/latest/'

file_changelog='changelog.html'
file_archive='talon-linux.tar.xz'

source_json_file='src.json'

set -e

# check dependencies
for cmd in curl jq sha256sum; do
  if ! command -v $cmd >/dev/null; then
    echo "error: please install $cmd"
    exit 1
  fi
done

cd "$(dirname "$0")"

# parse old source info
old_source_json="$(< $source_json_file)"
contentLength="$(echo "$old_source_json" | jq -r .contentLength)"
lastModified="$(echo "$old_source_json" | jq -r .lastModified)"

# fetch actual source info
url="$urlbase$file_archive"
echo "fetching headers from $url ..."
headers=$(curl -L -I $url)
echo "headers:"
echo "$headers"
# note: -1 to remove trailing \r
contentLengthActual=$(echo "$headers" | grep "^Content-Length:" | tail -n1)
contentLengthActual=''${contentLengthActual:16: -1}
lastModifiedActual=$(echo "$headers" | grep "^Last-Modified:" | tail -n1)
lastModifiedActual=''${lastModifiedActual:15: -1}

if [[ "$contentLengthActual" == "$contentLength" && "$lastModifiedActual" == "$lastModified" ]]
then
    echo "done: source is up-to-date"
    exit
fi

echo "note: original url has changed:"
if [[ "$contentLengthActual" != "$contentLength" ]]; then
    echo "-Content-Length: $contentLength"
    echo "+Content-Length: $contentLengthActual"
fi
if [[ "$lastModifiedActual" != "$lastModified" ]]; then
    echo "-Last-Modified: $lastModified"
    echo "+Last-Modified: $lastModifiedActual"
fi

tempfile=$(mktemp --suffix=-$file_archive)
echo "fetching file from $url to $tempfile ..."
# TODO restore
#curl -L $url -o $tempfile
echo foo >$tempfile # test
sha256Actual=$(sha256sum $tempfile)
sha256Actual=${sha256Actual:0:64}
rm $tempfile

url="$urlbase$file_changelog"
echo "fetching version from $url ..."
tempfile=$(mktemp --suffix=-$file_changelog)
curl -L $url -o $tempfile
# example: <h2>0.3.1 (Jul 28, 2022)</h2>
versionActual=$(head -n1 $tempfile | sed -E 's|^<h2>([0-9.]+).*?</h2>$|\1|')
rm $tempfile

# update source info
new_source_json="$(
    echo "$old_source_json" | jq --sort-keys --slurp '
        [.[0], {
            "contentLength": $contentLength,
            "lastModified": $lastModified,
            "mirrorUrls": []
        }] | add
    ' \
    --argjson contentLength "$contentLengthActual" \
    --arg lastModified "$lastModifiedActual"
)"

echo "new_source_json:"
echo "$new_source_json"

echo "$new_source_json" >$source_json_file

echo "todo: add mirror urls to $source_json_file"
