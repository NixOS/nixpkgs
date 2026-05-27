#!/usr/bin/env nix-shell
#!nix-shell -i bash -p bash nix-update common-updater-scripts nix jq

set -euo pipefail

currentVersion=$(nix-instantiate --eval -E "with import ./. {}; devin-cli.version or (lib.getVersion devin-cli)" | tr -d '"')
latestVersion=$(curl https://static.devin.ai/cli/current/manifest.json | jq '.version' | tr -d '"')

if [[ "$currentVersion" == "$latestVersion" ]]; then
    echo "package is up-to-date: $currentVersion"
    exit 0
fi

update-source-version devin-cli $latestVersion || true

for system in \
    x86_64-linux \
    aarch64-linux \
    x86_64-darwin \
    aarch64-darwin; do
    hash=$(nix --extra-experimental-features nix-command hash convert --to sri --hash-algo sha256 $(nix-prefetch-url $(nix-instantiate --eval -E "with import ./. {}; devin-cli.src.url" --system "$system" | tr -d '"')))
    update-source-version devin-cli $latestVersion $hash --system=$system --ignore-same-version
done
