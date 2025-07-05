#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl jq coreutils common-updater-scripts

latestVersion=$(curl "https://api.github.com/repos/archimatetool/archi/tags" | jq -r '.[0].name' | tail -c +9)
currentVersion=$(nix-instantiate --eval -E "with import ./. {}; archi.version or (lib.getVersion archi)" | tr -d '"')

echo "latest  version: $latestVersion"
echo "current version: $currentVersion"

if [[ "$latestVersion" == "$currentVersion" ]]; then
    echo "package is up-to-date"
    exit 0
fi

for i in \
    "aarch64-darwin Archi-Mac-Silicon-$latestVersion.dmg" \
    "x86_64-darwin Archi-Mac-$latestVersion.dmg" \
    "x86_64-linux Archi-Linux64-$latestVersion.tgz"
do
    set -- $i
    prefetch=$(nix-prefetch-url https://www.archimatetool.com/downloads/archi/$latestVersion/$2)
    hash=$(nix-hash --type sha256 --to-sri $prefetch)

    update-source-version archi $latestVersion $hash --system=$1 --ignore-same-version
done
