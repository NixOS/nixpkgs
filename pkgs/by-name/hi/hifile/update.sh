#!/usr/bin/env nix-shell
#!nix-shell -I nixpkgs=./. -i bash -p curl common-updater-scripts

latestVersion=$(curl -s "https://www.hifile.app/otherdownloads" | grep -A 10 '<h1>All downloads</h1>' | grep -m 1 '<li>.*AppImage.*' | sed -n 's/.*HiFile-\([0-9.]*\)\.AppImage.*/\1/p')
currentVersion=$(nix-instantiate --eval -E "with import ./. {}; hifile.version" | tr -d '"')

echo "latest  version: $latestVersion"
echo "current version: $currentVersion"

if [[ "$latestVersion" == "$currentVersion" ]]; then
    echo "package is up-to-date"
    exit 0
fi


prefetch=$(nix-prefetch-url "https://www.hifile.app/files/HiFile-$latestVersion.AppImage")
hash=$(nix-hash --type sha256 --to-sri "$prefetch")

update-source-version hifile 0 "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=" --system="x86_64-linux"
update-source-version hifile "$latestVersion" "$hash" --system="x86_64-linux"


