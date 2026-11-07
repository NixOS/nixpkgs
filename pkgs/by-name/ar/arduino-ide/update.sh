#!/usr/bin/env nix-shell
#!nix-shell -I nixpkgs=./. --pure -i bash -p bash cacert curl jq nix common-updater-scripts
set -euo pipefail

nix() { command nix --extra-experimental-features nix-command "$@"; }

new_version="$(curl -s "https://api.github.com/repos/arduino/arduino-ide/releases/latest" | jq -r '.tag_name')"
old_version="$(nix eval --raw -f . arduino-ide.version)"

if [[ "$new_version" == "$old_version" ]]; then
    echo "Already up to date."
    exit 0
fi

echo "Updating arduino-ide from $old_version to $new_version..."

for pair in \
    'x86_64-linux:Linux_64bit.AppImage' \
    'aarch64-darwin:macOS_arm64.zip'
do
    system="${pair%%:*}"
    asset="arduino-ide_${new_version}_${pair#*:}"

    echo "Prefetching $asset..."
    hash="$(nix store prefetch-file --json --hash-type sha256 \
        "https://github.com/arduino/arduino-ide/releases/download/$new_version/$asset" | jq -r '.hash')"

    echo "$system ($asset): hash = $hash"
    update-source-version arduino-ide "$new_version" "$hash" --system="$system" --ignore-same-version
done
