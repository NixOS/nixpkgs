#!/usr/bin/env nix-shell
#!nix-shell -i bash -p bash nix curl coreutils common-updater-scripts nix-update

set -eou pipefail

currentVersion=$(nix-instantiate --eval -E "with import ./. {}; phoenixd.version or (lib.getVersion phoenixd)" | tr -d '"')
nix-update phoenixd --system x86_64-linux
latestVersion=$(nix-instantiate --eval -E "with import ./. {}; phoenixd.version or (lib.getVersion phoenixd)" | tr -d '"')

echo "latest  version: $latestVersion"
echo "current version: $currentVersion"

if [[ "$latestVersion" == "$currentVersion" ]]; then
    echo "package is up-to-date"
    exit 0
fi

for system in \
    aarch64-linux \
    x86_64-darwin \
    aarch64-darwin; do
    hash=$(nix --extra-experimental-features nix-command hash convert --to sri --hash-algo sha256 $(nix-prefetch-url $(nix-instantiate --eval -E "with import ./. {}; phoenixd.src.url" --system "$system" | tr -d '"')))
    update-source-version phoenixd $latestVersion $hash --system=$system --ignore-same-version
done
