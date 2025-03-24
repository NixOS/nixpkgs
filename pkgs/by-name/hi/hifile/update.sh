#!/usr/bin/env nix-shell
#!nix-shell -I nixpkgs=./. -i bash -p curl nix-update

latestVersion=$(curl -s "https://www.hifile.app/otherdownloads" | grep -A 10 '<h1>All downloads</h1>' | grep -m 1 '<li>.*AppImage.*' | sed -n 's/.*HiFile-\([0-9.]*\)\.AppImage.*/\1/p')
currentVersion=$(nix-instantiate --eval -E "with import ./. {}; hifile.version" | tr -d '"')

echo "latest  version: $latestVersion"
echo "current version: $currentVersion"

if [[ "$latestVersion" == "$currentVersion" ]]; then
    echo "package is up-to-date"
    exit 0
fi


nix-update hifile --version $latestVersion
