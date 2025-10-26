#!/usr/bin/env nix-shell
#!nix-shell -I nixpkgs=./. --pure -i bash -p bash cacert curl jq nix unzip common-updater-scripts
set -euo pipefail

new_tag_name="$(curl -s "https://api.github.com/repos/ppy/osu/releases/latest" | jq -r '.name')"
new_version="${new_tag_name%-lazer}"
old_version="$(nix eval --raw -f . osu-lazer-bin.version)"

if [[ "$new_version" == "$old_version" ]]; then
    echo "Already up to date."
    exit 0
fi

echo "Updating osu-lazer-bin from $old_version to $new_version..."

for pair in \
    'aarch64-darwin osu.app.Apple.Silicon.zip' \
    'x86_64-darwin osu.app.Intel.zip' \
    'x86_64-linux osu.AppImage'
do
    set -- $pair
    echo "Prefetching binary for $1..."
    prefetch_output=$(nix --extra-experimental-features nix-command store prefetch-file --json --hash-type sha256 "https://github.com/ppy/osu/releases/download/$new_tag_name/$2")
    if [[ "$1" == *"darwin"* ]]; then
        store_path=$(jq -r '.storePath' <<<"$prefetch_output")
        tmpdir=$(mktemp -d)
        unzip -q "$store_path" -d "$tmpdir"
        hash=$(nix --extra-experimental-features nix-command hash path "$tmpdir")
        rm -r "$tmpdir"
    else
        hash=$(jq -r '.hash' <<<"$prefetch_output")
    fi
    echo "$1 ($2): hash = $hash"
    update-source-version osu-lazer-bin "$new_version" "$hash" --system="$1" --ignore-same-version
done
