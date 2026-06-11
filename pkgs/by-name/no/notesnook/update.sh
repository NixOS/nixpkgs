#!/usr/bin/env nix-shell
#!nix-shell -i bash -p bash curl jq common-updater-scripts

set -xe

latestTag=$(curl ${GITHUB_TOKEN:+-u":$GITHUB_TOKEN"} https://api.github.com/repos/streetwriters/notesnook/releases/latest | jq -r ".tag_name")
latestVersion="$(expr "$latestTag" : 'v\(.*\)')"
currentVersion=$(nix-instantiate --eval -E "with import ./. {}; notesnook.version or (lib.getVersion notesnook)" | tr -d '"')

echo "latest  version: $latestVersion"
echo "current version: $currentVersion"

if [[ "$latestVersion" == "$currentVersion" ]]; then
    echo "package is up-to-date"
    exit 0
fi

for i in \
  "x86_64-linux linux_x86_64.AppImage" \
  "aarch64-linux linux_arm64.AppImage" \
  "x86_64-darwin mac_x64.dmg" \
  "aarch64-darwin mac_arm64.dmg"; do
  set -- $i
  hash=$(nix-hash --to-sri --type sha256 "$(nix-prefetch-url "https://github.com/streetwriters/notesnook/releases/download/v$latestVersion/notesnook_$2")")
  update-source-version notesnook $latestVersion $hash --system=$1 --ignore-same-version
done
