#!/usr/bin/env nix-shell
#!nix-shell -i bash -p common-updater-scripts curl jq nix nix-update

set -euo pipefail

attr="${UPDATE_NIX_ATTR_PATH:-galene-stt}"

nix-update "$attr" "$@"

old_url="$(nix eval --raw -f . "$attr.passthru.testModel.url")"
new_rev="$(curl -sSf https://huggingface.co/api/models/ggerganov/whisper.cpp | jq -r .sha)"
new_url="https://huggingface.co/ggerganov/whisper.cpp/resolve/$new_rev/ggml-tiny.en.bin"

if [[ "$old_url" == "$new_url" ]]; then
    echo "$attr: test model is already up to date ($new_rev)."
    exit 0
fi

echo "$attr: updating test model to $new_rev..."
version="$(nix eval --raw -f . "$attr.version")"
new_hash="$(nix store prefetch-file --json "$new_url" | jq -r .hash)"

update-source-version "$attr" "$version" "$new_hash" "$new_url" \
    --source-key=passthru.testModel \
    --ignore-same-version
