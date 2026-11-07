#!/usr/bin/env nix-shell
#!nix-shell -i bash -p bash coreutils gnugrep git jq nix nix-update
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

# windowtolayer, see packaging/linux/build-windowtolayer.mjs
w2l_script="$src/packaging/linux/build-windowtolayer.mjs"
w2l_url=$(grep -oP "UPSTREAM_URL = '\K[^']+" "$w2l_script")
w2l_rev=$(grep -oP "PINNED_REV = '\K[0-9a-f]{40}" "$w2l_script")
w2l_patches=$(grep -oP "^\s+'\K[^']+\.patch(?=',?$)" "$w2l_script" | jq -Rnc '[inputs]')
if [[ $(jq -r '.windowtolayer.rev // empty' "$sources") == "$w2l_rev" ]]; then
  w2l=$(jq -c '.windowtolayer | del(.patches)' "$sources")
else
  w2l_git=$(mktemp -d)
  trap 'rm -rf "$w2l_git"' EXIT
  git clone --quiet --bare --filter=blob:none "$w2l_url" "$w2l_git"
  w2l_tag=$(git -C "$w2l_git" describe --tags --abbrev=0 "$w2l_rev")
  w2l_date=$(git -C "$w2l_git" show -s --format=%cs "$w2l_rev")
  w2l=$(jq -nc \
    --arg version "${w2l_tag#v}-unstable-$w2l_date" \
    --arg rev "$w2l_rev" \
    --arg hash "$(prefetch_unpack "${w2l_url%.git}/-/archive/$w2l_rev/windowtolayer-$w2l_rev.tar.gz")" \
    '{ version: $version, rev: $rev, hash: $hash, cargoHash: "" }')
fi
w2l=$(jq -c --argjson patches "$w2l_patches" '. + { patches: $patches }' <<<"$w2l")

jq -n \
  --arg rev "$mnn_rev" \
  --arg hash "$mnn_hash" \
  --argjson models "$models" \
  --argjson windowtolayer "$w2l" \
  '{ mnn: { rev: $rev, hash: $hash }, models: $models, windowtolayer: $windowtolayer }' >"$sources"

if [[ -z $(jq -r '.windowtolayer.cargoHash' "$sources") ]]; then
  cargo_hash=$(
    nix-build --no-out-link -A "$attr.windowtolayer.cargoDeps" 2>&1 |
      grep -oP 'got:\s+\Ksha256-\S+' || true
  )
  if [[ -z $cargo_hash ]]; then
    echo "failed to determine cargoHash of windowtolayer" >&2
    exit 1
  fi
  jq --arg hash "$cargo_hash" '.windowtolayer.cargoHash = $hash' "$sources" >"$sources.tmp"
  mv "$sources.tmp" "$sources"
fi
