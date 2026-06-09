#!/usr/bin/env nix-shell
#!nix-shell -i bash -p bash nix-update common-updater-scripts nix jq

set -euo pipefail

currentVersion=$(nix-instantiate --eval --raw -E "with import ./. {}; leetgpu.version or (lib.getVersion leetgpu)")
latestVersion=$(curl https://cli.leetgpu.com/latest)

if [[ "$currentVersion" == "$latestVersion" ]]; then
    echo "package is up-to-date: $currentVersion"
    exit 0
fi

update-source-version leetgpu $latestVersion || true

for system in \
    x86_64-linux \
    aarch64-linux \
    x86_64-darwin \
    aarch64-darwin; do
    hash=$(nix store prefetch-file --json --hash-type sha256 \
      $(nix-instantiate --eval --raw -E "with import ./. {}; leetgpu.src.url" --system "$system") | jq -r '.hash')
    update-source-version leetgpu $latestVersion $hash --system=$system --ignore-same-version
done
