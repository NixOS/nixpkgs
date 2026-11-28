#!/usr/bin/env nix-shell
#!nix-shell -I nixpkgs=./. -i bash -p curl jq nix

# shellcheck shell=bash
set -euo pipefail
shopt -s failglob

repo=lklynet/aurral-plugins
package_dir=pkgs/by-name/au/aurral

discover_plugins() {
    local manifest dir
    for manifest in "$1"/*/manifest.json; do
        dir=${manifest%/*}
        if [[ ! -f "$dir/index.js" ]]; then
            echo "Missing plugin entry point: $dir/index.js" >&2
            return 1
        fi

        jq -ce --arg id "${dir##*/}" '
            select(.id == $id and (.id | test("\\A[a-z0-9][a-z0-9-]*\\z")))
            | select([.name, .version, .description] | all(type == "string"))
            | {key: .id, value: {name, version, description}}
        ' "$manifest" || {
            echo "Invalid plugin manifest: $manifest" >&2
            return 1
        }
    done
}

# Pin the latest release and unpack it in the Nix store.
tag=$(curl -fsSL "https://api.github.com/repos/$repo/releases/latest" | jq -er '.tag_name')
encoded_tag=$(jq -nr --arg tag "$tag" '$tag | @uri')
source=$(nix --extra-experimental-features nix-command store prefetch-file --json --unpack \
    --name source "https://github.com/$repo/archive/refs/tags/$encoded_tag.tar.gz")
src=$(jq -er '.storePath' <<< "$source")
source_hash=$(jq -er '.hash' <<< "$source")

# Build the new index from the release manifests.
tmp=$(mktemp -d "$package_dir/.update-plugins.XXXXXXXX")
trap 'rm -rf -- "$tmp"' EXIT
index=$tmp/plugins.json
discover_plugins "$src" | jq -s --arg tag "$tag" --arg hash "$source_hash" \
    '{tag: $tag, hash: $hash, plugins: (sort_by(.key) | from_entries)}' > "$index"

mv -- "$index" "$package_dir/plugins.json"
