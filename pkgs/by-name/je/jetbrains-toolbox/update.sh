#!/usr/bin/env nix-shell
#!nix-shell -i bash -p bash nix curl coreutils jq common-updater-scripts

set -eou pipefail

latestVersion=$(curl -Ls 'https://data.services.jetbrains.com/products?code=TBA&release.type=release' | jq -r '.[0].releases | flatten | .[0].build')
currentVersion=$(nix-instantiate --eval -E "with import ./. {}; jetbrains-toolbox.version" | tr -d '"')

echo "latest  version: $latestVersion"
echo "current version: $currentVersion"

if [[ "$latestVersion" == "$currentVersion" ]]; then
    echo "package is up-to-date"
    exit 0
fi

update-source-version jetbrains-toolbox $latestVersion

systems=$(nix-instantiate --eval --json -E 'with import ./. {}; jetbrains-toolbox.meta.platforms' | jq -r '.[]')

for system in $systems; do
    arch="${system%%:*}"
    suffix="${system#*:}"
    url=$(nix-instantiate --eval --json -E "with import ./. { system = \"$system\"; }; jetbrains-toolbox.src.url" | jq -r)
    if [[ $url == *.tar.gz ]]; then
      unpack="--unpack"
    else
      unpack=""
    fi
    prefetch=$(nix-prefetch-url $unpack "$url")
    hash=$(nix --extra-experimental-features nix-command hash convert --hash-algo sha256 --to sri $prefetch)
    update-source-version jetbrains-toolbox $latestVersion $hash --system=$system --ignore-same-version
done
