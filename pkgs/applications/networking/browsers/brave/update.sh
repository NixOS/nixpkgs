#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl gnused nix-update

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"

latestVersion="$(curl -sL https://brave-browser-apt-release.s3.brave.com/dists/stable/main/binary-amd64/Packages | sed -r -n 's/^Version: (.*)/\1/p' | head -n1)"
latestVersionAarch64="$(curl -sL https://brave-browser-apt-release.s3.brave.com/dists/stable/main/binary-arm64/Packages | sed -r -n 's/^Version: (.*)/\1/p' | head -n1)"

echo "Updating brave for x86_64-linux"
nix-update --version "$latestVersion" \
    --system x86_64-linux \
    --override-filename "$SCRIPT_DIR/brave.nix" \
    brave

echo "Updating brave for aarch64-linux"
nix-update --version "$latestVersionAarch64" \
    --system aarch64-linux \
    --override-filename "$SCRIPT_DIR/brave-aarch64.nix" \
    brave
