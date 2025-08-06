#!/usr/bin/env nix-shell
#!nix-shell -i bash -p bash nix-update common-updater-scripts nix

set -euo pipefail

currentVersion=$(nix-instantiate --eval -E "with import ./. {}; dbgate.version or (lib.getVersion dbgate)" | tr -d '"')
nix-update dbgate
latestVersion=$(nix-instantiate --eval -E "with import ./. {}; dbgate.version or (lib.getVersion dbgate)" | tr -d '"')

if [[ "$currentVersion" == "$latestVersion" ]]; then
    echo "package is up-to-date: $currentVersion"
    exit 0
fi

for system in \
    x86_64-linux \
    aarch64-linux \
    x86_64-darwin \
    aarch64-darwin; do
    hash=$(nix --extra-experimental-features nix-command hash convert --to sri --hash-algo sha256 $(nix-prefetch-url $(nix-instantiate --eval -E "with import ./. {}; dbgate.src.url" --system "$system" | tr -d '"')))
    update-source-version dbgate $latestVersion $hash --system=$system --ignore-same-version
done
