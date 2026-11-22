#!/usr/bin/env nix-shell
#!nix-shell -i bash -p common-updater-scripts curl jq nix nix-update

set -euo pipefail

nix-update --use-github-releases dep-scan "$@"

new_rev="$(curl -sSf "https://huggingface.co/api/datasets/AppThreat/vdb" | jq -r .sha)"
old_url="$(nix eval --raw -f . "dep-scan.passthru.vdb.meta.url")"
new_url="https://huggingface.co/datasets/AppThreat/vdb/resolve/$new_rev/app-2y/vdb.meta"

if [[ "$old_url" == "$new_url" ]]; then
    echo "dep-scan: VDB dataset models are already up to date ($new_rev)."
    exit 0
fi

echo "dep-scan: updating VDB dataset models to $new_rev..."
version="$(nix eval --raw -f . "dep-scan.version")"
base_url="https://huggingface.co/datasets/AppThreat/vdb/resolve/$new_rev/app-2y"

for entry in "index:data.index.vdb6" "data:data.vdb6" "meta:vdb.meta"; do
    key="${entry%%:*}"
    file="${entry##*:}"
    url="$base_url/$file"
    hash="$(nix store prefetch-file --json "$url" | jq -r .hash)"

    update-source-version dep-scan "$version" "$hash" "$url" \
        --source-key="passthru.vdb.$key" \
        --ignore-same-version
done
