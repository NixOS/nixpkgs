#!/usr/bin/env nix-shell
#!nix-shell -i bash -p bash nix-update common-updater-scripts nix

set -euo pipefail

currentVersion=$(nix-instantiate --eval -E "with import ./. {}; hamrs-pro.version or (lib.getVersion hamrs-pro)" | tr -d '"')
# extracting version from download link
latestVersion=$(curl -sL https://hamrs.app | grep -Po '(?<=hamrs-pro-)[0-9]+\.[0-9]+\.[0-9]+(?=-linux-x86_64\.AppImage)')

if [[ "$currentVersion" == "$latestVersion" ]]; then
    echo "package is up-to-date: $currentVersion"
    exit 0
fi

update-source-version hamrs-pro $latestVersion || true

for system in \
    x86_64-linux \
    aarch64-linux \
    x86_64-darwin \
    aarch64-darwin; do
    hash=$(nix --extra-experimental-features nix-command hash convert --to sri --hash-algo sha256 $(nix-prefetch-url $(nix-instantiate --eval -E "with import ./. {}; hamrs-pro.src.url" --system "$system" | tr -d '"')))
    update-source-version hamrs-pro $latestVersion $hash --system=$system --ignore-same-version
done
