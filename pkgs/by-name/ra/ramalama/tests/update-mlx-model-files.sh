#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
metadata_file="$script_dir/mlx-model-files.json"

if [[ $# -gt 0 ]]; then
    repo="$1"
    revision="${2:-main}"
else
    repo="$(jq --raw-output '.repo' "$metadata_file")"
    revision="$(jq --raw-output '.revision' "$metadata_file")"
fi

license="$(jq --raw-output '.license' "$metadata_file")"
model_json="$(curl --fail --silent --show-error "https://huggingface.co/api/models/$repo/revision/$revision")"
resolved_revision="$(jq --raw-output '.sha' <<<"$model_json")"
base_url="https://huggingface.co/$repo/resolve/$resolved_revision"

files=$(
    jq --raw-output '
      .siblings[].rfilename
      # Keep the test closure to files needed by MLX at runtime. Hugging Face
      # repos often also contain docs, examples, or alternate model formats.
      | select(
          . == "config.json"
          or . == "generation_config.json"
          or . == "tokenizer.json"
          or . == "tokenizer_config.json"
          or . == "special_tokens_map.json"
          or . == "vocab.json"
          or . == "merges.txt"
          or endswith(".safetensors")
          or endswith(".safetensors.index.json")
        )
    ' <<<"$model_json"
)

files_json="$(mktemp)"
trap 'rm -f "$files_json"' EXIT

while IFS= read -r name; do
    [[ -n "$name" ]] || continue

    url="$base_url/$name"
    prefetch_output="$(nix-prefetch-url "$url")"
    # nix-prefetch-url prints the Nix base32 hash on its final stdout line.
    hash32="$(tail -n 1 <<<"$prefetch_output")"
    hash="$(nix hash convert --hash-algo sha256 --to sri "$hash32")"

    type="other"
    if [[ "$name" == *.safetensors ]]; then
        type="safetensor"
    fi

    jq --null-input \
      --arg name "$name" \
      --arg hash "$hash" \
      --arg type "$type" \
      '{name: $name, hash: $hash, type: $type}' \
      >>"$files_json"
done <<<"$files"

jq --slurp \
  --arg repo "$repo" \
  --arg revision "$resolved_revision" \
  --arg license "$license" \
  '{
    repo: $repo,
    revision: $revision,
    license: $license,
    files: .
  }' \
  "$files_json" \
  >"$metadata_file.tmp"

mv "$metadata_file.tmp" "$metadata_file"
