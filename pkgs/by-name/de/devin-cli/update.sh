#!/usr/bin/env nix-shell
#!nix-shell -i bash -p bash nix-update common-updater-scripts nix jq

set -euo pipefail

currentVersion=$(nix-instantiate --eval --raw -E "with import ./. {}; devin-cli.version or (lib.getVersion devin-cli)")
latestVersion=$(curl https://static.devin.ai/cli/current/manifest.json | jq -r '.version')

if [[ "$currentVersion" == "$latestVersion" ]]; then
    echo "package is up-to-date: $currentVersion"
    exit 0
fi

update-source-version devin-cli $latestVersion || true

for system in \
    x86_64-linux \
    aarch64-linux \
    aarch64-darwin; do
    hash=$(nix store prefetch-file --json --hash-type sha256 \
      $(nix-instantiate --eval --raw -E "with import ./. {}; devin-cli.src.url" --system "$system") | jq -r '.hash')
    update-source-version devin-cli $latestVersion $hash --system=$system --ignore-same-version
done
