#!/usr/bin/env nix-shell
#!nix-shell -I nixpkgs=./. --pure -i bash -p curl cacert git nix nix-update

versionList=$(curl -s "https://www.hifile.app/otherdownloads" | grep -A 10 '<h1>All downloads</h1>' | grep -oP 'HiFile-\K[0-9.]+(?=\.AppImage)')

# Get the latest version by sorting the list of versions
latestVersion=$(echo "$versionList" | sort -V | tail -n 1)

currentVersion=$(nix-instantiate --eval -E "with import ./. {}; hifile.version" | tr -d '"')

echo "latest  version: $latestVersion"
echo "current version: $currentVersion"

if [[ "$latestVersion" == "$currentVersion" ]]; then
    echo "package is up-to-date"
    exit 0
fi


nix-update hifile --version $latestVersion
