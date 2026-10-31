#!/usr/bin/env nix-shell
#!nix-shell -i bash -p bash coreutils gnugrep jq nix nix-update
# shellcheck shell=bash

set -euo pipefail

attr=${UPDATE_NIX_ATTR_PATH:-folia-major}
dir=$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")
sources="$dir/sources.json"
cd "$dir/../../../.."

nix-update "$attr" --use-github-releases

src=$(nix-build --no-out-link -A "$attr.src")

to_sri() {
  nix --extra-experimental-features nix-command hash convert --hash-algo sha256 --to sri "$1"
}

prefetch_unpack() {
  to_sri "$(nix-prefetch-url --unpack "$1")"
}

# MNN, see build/buildMnnRuntime.mjs
mnn_rev=$(grep -oP "MNN_COMMIT = '\K[0-9a-f]{40}" "$src/build/buildMnnRuntime.mjs")
mnn_hash=$(prefetch_unpack "https://github.com/alibaba/MNN/archive/$mnn_rev.tar.gz")

# Models, see shared/modelManifest.json
manifest="$src/shared/modelManifest.json"
mirror=$(jq -r '.mirrors[] | select(startswith("https://github.com/chthollyphile/folia-major/"))' "$manifest")
models='[]'
while IFS=$'\t' read -r file sha256; do
  models=$(jq -c \
    --arg url "${mirror/\{file\}/$file}" \
    --arg hash "$(to_sri "$sha256")" \
    '. + [{ url: $url, hash: $hash }]' <<<"$models")
done < <(jq -r '.models[] | [.file, .sha256] | @tsv' "$manifest")

jq -n \
  --arg rev "$mnn_rev" \
  --arg hash "$mnn_hash" \
  --argjson models "$models" \
  '{ mnn: { rev: $rev, hash: $hash }, models: $models }' >"$sources"
