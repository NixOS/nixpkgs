#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
metadata_file="$script_dir/mlx-model-files.json"

repo="$(jq --raw-output '.repo' "$metadata_file")"
model_json="$(curl --fail --silent --show-error "https://huggingface.co/api/models/$repo/revision/main")"
resolved_revision="$(jq --raw-output '.sha' <<<"$model_json")"
base_url="https://huggingface.co/$repo/resolve/$resolved_revision"

files=$(
    jq --raw-output '
      .siblings[].rfilename
      # Keep the test closure to files needed by MLX at runtime. Hugging Face
      # repos often also contain docs, examples, or alternate model formats.
      | select(
          . == "config.json"
          or . == "tokenizer.json"
          or . == "tokenizer_config.json"
          or (startswith("model") and endswith(".safetensors"))
        )
    ' <<<"$model_json"
)

files_json="$(mktemp)"
trap 'rm -f "$files_json"' EXIT

while IFS= read -r name; do
    url="$base_url/$name"
    hash32="$(nix-prefetch-url "$url")"
    hash="$(nix hash convert --hash-algo sha256 --to sri "$hash32")"

    jq --null-input \
      --arg name "$name" \
      --arg hash "$hash" \
      '{name: $name, hash: $hash}' \
      >>"$files_json"
done <<<"$files"

jq --slurp \
  --arg revision "$resolved_revision" \
  '. as $inputs
  | $inputs[0]
  | .revision = $revision
  | .files = $inputs[1:]' \
  "$metadata_file" \
  "$files_json" \
  >"$metadata_file.tmp"

mv "$metadata_file.tmp" "$metadata_file"
