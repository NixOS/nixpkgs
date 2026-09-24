#!/usr/bin/env nix-shell
#!nix-shell -i bash -p bash nixVersions.latest curl coreutils jq common-updater-scripts

set -euo pipefail

latestTag=$(curl ${GITHUB_TOKEN:+-u ":$GITHUB_TOKEN"} -sL https://api.github.com/repos/janhq/jan/releases/latest | jq -r ".tag_name")
latestVersion="${latestTag#v}"
currentVersion=$(nix-instantiate --eval -E "with import ./. {}; jan.version" | tr -d '"')

echo "latest  version: $latestVersion"
echo "current version: $currentVersion"

if [[ "$latestVersion" == "$currentVersion" ]]; then
    echo "package is up-to-date"
    exit 0
fi

linuxUrl="https://github.com/janhq/jan/releases/download/v$latestVersion/Jan_${latestVersion}_amd64.AppImage"
linuxHash=$(nix --extra-experimental-features nix-command hash convert --hash-algo sha256 --to sri "$(nix-prefetch-url "$linuxUrl")")
update-source-version jan "$latestVersion" "$linuxHash" --system=x86_64-linux --ignore-same-version

darwinUrl="https://github.com/janhq/jan/releases/download/v$latestVersion/jan-mac-universal-${latestVersion}.zip"
darwinHash=$(nix --extra-experimental-features nix-command hash convert --hash-algo sha256 --to sri "$(nix-prefetch-url --unpack "$darwinUrl")")
update-source-version jan "$latestVersion" "$darwinHash" --system=aarch64-darwin --ignore-same-version
