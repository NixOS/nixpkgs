#!/usr/bin/env nix-shell
#!nix-shell -I nixpkgs=./. -i bash -p curl jq

latestVersion=$(curl "https://api.github.com/repos/dbeaver/dbeaver/tags" | jq -r '.[0].name')
currentVersion=$(nix-instantiate --eval -E "with import ./. {}; dbeaver-bin.version" | tr -d '"')

echo "latest  version: $latestVersion"
echo "current version: $currentVersion"

if [[ "$latestVersion" == "$currentVersion" ]]; then
    echo "package is up-to-date"
    exit 0
fi

for i in \
    "x86_64-linux linux.gtk.x86_64-nojdk.tar.gz" \
    "aarch64-linux linux.gtk.aarch64-nojdk.tar.gz"
do
    set -- $i
    prefetch=$(nix-prefetch-url "https://github.com/dbeaver/dbeaver/releases/download/$latestVersion/dbeaver-ce-$latestVersion-$2")
    hash=$(nix-hash --type sha256 --to-sri $prefetch)

    update-source-version dbeaver-bin 0 "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=" --system=$1
    update-source-version dbeaver-bin $latestVersion $hash --system=$1
done
