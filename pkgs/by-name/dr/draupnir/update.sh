#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl common-updater-scripts coreutils jq

set -euo pipefail
set -x

echo "Getting versions..."
latestVersion="$(curl -sL "https://api.github.com/repos/the-draupnir-project/Draupnir/releases?per_page=1" | jq -r '.[0].tag_name | ltrimstr("v")')"
echo " --> Latest version: ${latestVersion}"
currentVersion=$(nix-instantiate --eval -E "with import ./. {}; draupnir.version or (lib.getVersion draupnir)" | tr -d '"')
echo " --> Current version: ${currentVersion}"
if [[ "$currentVersion" == "$latestVersion" ]]; then
  echo "Draupnir is up-to-date: $currentVersion"
  exit 0
else
  echo "We are out of date..."
fi

curl https://raw.githubusercontent.com/the-draupnir-project/Draupnir/v$latestVersion/package.json -o pkgs/by-name/dr/draupnir/package.json
OLD_HASH=`nix-hash --type sha256 --flat --base32 --sri <(curl https://raw.githubusercontent.com/the-draupnir-project/Draupnir/v$currentVersion/yarn.lock)`

update-source-version draupnir "$latestVersion"

NEW_HASH=`nix-hash --type sha256 --flat --base32 --sri <(curl https://raw.githubusercontent.com/the-draupnir-project/Draupnir/v$latestVersion/yarn.lock)`

echo Got old yarn.lock hash: $OLD_HASH
echo Got new yarn.lock hash: $NEW_HASH

sed -i 's/'${OLD_HASH/\//\\/}'/'${NEW_HASH/\//\\/}'/' pkgs/by-name/dr/draupnir/default.nix
