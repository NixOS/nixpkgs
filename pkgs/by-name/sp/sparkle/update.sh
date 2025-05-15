#!/usr/bin/env nix-shell
#!nix-shell -i bash -p bash nix curl coreutils common-updater-scripts nix-update

currentVersion=$(nix-instantiate --eval -E "with import ./. {}; sparkle.version or (lib.getVersion sparkle)" | tr -d '"')
nix-update sparkle
latestVersion=$(nix-instantiate --eval -E "with import ./. {}; sparkle.version or (lib.getVersion sparkle)" | tr -d '"')

echo "latest  version: $latestVersion"
echo "current version: $currentVersion"

if [[ "$latestVersion" == "$currentVersion" ]]; then
    echo "package is up-to-date"
    exit 0
fi

hash=$(nix hash convert --to sri --hash-algo sha256 $(nix-prefetch-url $(nix-instantiate --eval -E "with import ./. {}; sparkle.src.url" --system aarch64-linux | tr -d '"')))
update-source-version sparkle $latestVersion $hash --system=aarch64-linux --ignore-same-version
