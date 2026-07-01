#!/usr/bin/env nix-shell
#!nix-shell -i bash -p bash nix-update common-updater-scripts nix jq

set -euo pipefail

baseUrl=https://storage.googleapis.com/antigravity-public/antigravity-cli

currentVersion=$(nix-instantiate --eval --raw -E "with import ./. {}; antigravity-cli.version or (lib.getVersion antigravity-cli)")
latestVersion=$(curl $baseUrl/latest)

if [[ "$currentVersion" == "$latestVersion" ]]; then
    echo "package is up-to-date: $currentVersion"
    exit 0
fi

# urls unfortunately include a weird buildid that make it hard to get
latestWholeVersion=$(curl $baseUrl/$latestVersion/manifest.json | jq -r '.platforms."linux-x64".url' | cut -d/ -f6)

update-source-version --version-key=wholeVersion antigravity-cli $latestWholeVersion || true

for system in \
    x86_64-linux \
    aarch64-linux \
    x86_64-darwin \
    aarch64-darwin; do
    hash=$(nix store prefetch-file --json --hash-type sha256 \
      $(nix-instantiate --eval --raw -E "with import ./. {}; antigravity-cli.src.url" --system "$system") | jq -r '.hash')
    update-source-version --version-key=wholeVersion antigravity-cli $latestWholeVersion $hash --system=$system --ignore-same-version
done
