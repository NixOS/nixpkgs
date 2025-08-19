#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl common-updater-scripts coreutils jq prefetch-yarn-deps git

set -euo pipefail
set -x

cd  "$(git rev-parse --show-toplevel)"

TMPDIR=$(mktemp -d)

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

update-source-version draupnir "$latestVersion"

# Update yarn offline cache hash
cd $TMPDIR

curl https://raw.githubusercontent.com/the-draupnir-project/Draupnir/v$latestVersion/yarn.lock -o yarn.lock
TMP_PREFETCH_HASH=`prefetch-yarn-deps yarn.lock`
NEW_YARN_OFFLINE_HASH=`nix --extra-experimental-features nix-command hash to-sri --type sha256 $TMP_PREFETCH_HASH`

cd -
echo "New yarn offline hash: $NEW_YARN_OFFLINE_HASH"

TMPFILE=$(mktemp)
jq '.yarn_offline_cache_hash = "'$NEW_YARN_OFFLINE_HASH'"' pkgs/by-name/dr/draupnir/hashes.json > $TMPFILE
mv -- "$TMPFILE" pkgs/by-name/dr/draupnir/hashes.json
