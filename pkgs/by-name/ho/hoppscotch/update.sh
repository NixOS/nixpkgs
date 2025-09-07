#!/usr/bin/env nix-shell
#!nix-shell -i bash -p bash nix-update common-updater-scripts nix jq

set -euo pipefail

currentVersion=$(nix-instantiate --eval -E "with import ./. {}; hoppscotch.version or (lib.getVersion hoppscotch)" | tr -d '"')
latestVersion=$(curl ${GITHUB_TOKEN:+-u ":$GITHUB_TOKEN"} -sL https://api.github.com/repos/hoppscotch/releases/releases/latest | jq --raw-output .tag_name | sed 's/^v//')

if [[ "$currentVersion" == "$latestVersion" ]]; then
    echo "package is up-to-date: $currentVersion"
    exit 0
fi

update-source-version hoppscotch $latestVersion || true

for system in \
    x86_64-linux \
    x86_64-darwin \
    aarch64-darwin; do
    hash=$(nix hash convert --to sri --hash-algo sha256 $(nix-prefetch-url $(nix-instantiate --eval -E "with import ./. {}; hoppscotch.src.url" --system "$system" | tr -d '"')))
    update-source-version hoppscotch $latestVersion $hash --system=$system --ignore-same-version
done
