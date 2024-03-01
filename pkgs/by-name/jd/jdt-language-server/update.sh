#! /usr/bin/env nix-shell
#! nix-shell -i bash --pure -p curl cacert libxml2 yq nix jq

set -euo pipefail

cd "$(dirname "${BASH_SOURCE[0]}")"
DRV_DIR="$PWD"

# scrape the downloads page for release info
newver=$(curl -s 'https://download.eclipse.org/jdtls/milestones/' | xmllint --html - --xmlout 2>/dev/null | xq --raw-output '.html.body.main.div.div.div[0].div.table.tr | max_by(.td[3]).td[1].a.["#text"]')

prefix="https://download.eclipse.org/jdtls/milestones/$newver"

filename=$(curl -s "$prefix/latest.txt")
newtimestamp=$(echo $filename | sed "s|^.*-$newver-||;s|\.tar\.gz$||")
newhash="$(nix-hash --to-sri --type sha256 $(nix-prefetch-url "$prefix/$filename"))";

sed -i default.nix \
    -e "/^  version =/ s|\".*\"|\"$newver\"|" \
    -e "/^  timestamp =/ s|\".*\"|\"$newtimestamp\"|" \
    -e "/^    hash =/ s|\".*\"|\"$newhash\"|" \
