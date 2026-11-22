#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl jq common-updater-scripts nix
set -euo pipefail

declare -A arch_for=(
  [x86_64-linux]=x64
  [aarch64-linux]=arm64
)

version=
declare -A hash_for=()

for system in "${!arch_for[@]}"; do
  latest=$(curl -sSfL "https://pkgs.fluxer.com/desktop/stable/linux/${arch_for[$system]}/latest.json")

  current_version=$(jq -er '.version' <<<"$latest")
  current_hash=$(nix hash convert --hash-algo sha256 --to sri \
    "$(jq -er '.files.appimage.sha256' <<<"$latest")")

  if [[ -n $version && $version != "$current_version" ]]; then
    echo "error: $system published $current_version, expected $version" >&2
    exit 1
  fi

  version=$current_version
  hash_for[$system]=$current_hash
done

for system in "${!arch_for[@]}"; do
  update-source-version fluxer-bin "$version" "${hash_for[$system]}" \
    --system="$system" --ignore-same-version
done
