#!/usr/bin/env nix-shell
#!nix-shell -i bash -p jq nix-prefetch-docker nix-update nixfmt

set -euo pipefail

cd "$(git rev-parse --show-toplevel)"

podman_images="pkgs/by-name/ra/ramalama/tests/podman-images.json"

if [[ $# -gt 0 ]]; then
  nix-update --format --version "${1#v}" ramalama
else
  nix-update --format --use-github-releases ramalama
fi

version="$(nix-instantiate --eval -A ramalama.version | jq --raw-output .)"

image_name="quay.io/ramalama/ramalama"
image_tag="${version%.*}"

prefetch_image() {
  local arch="$1"
  nix-prefetch-docker \
    --json \
    --quiet \
    --arch "$arch" \
    "$image_name" \
    "$image_tag"
}

amd64_image="$(prefetch_image amd64)"
arm64_image="$(prefetch_image arm64)"

jq \
  --null-input \
  --arg imageName "$image_name" \
  --arg imageTag "$image_tag" \
  --argjson amd64 "$amd64_image" \
  --argjson arm64 "$arm64_image" \
  'if $amd64.imageDigest != $arm64.imageDigest then
    error("image digest differs between architectures")
  else {
    imageName: $imageName,
    imageTag: $imageTag,
    imageDigest: $amd64.imageDigest,
    images: {
      "x86_64-linux": {
        arch: "amd64",
        hash: $amd64.hash
      },
      "aarch64-linux": {
        arch: "arm64",
        hash: $arm64.hash
      }
    }
  } end' >"$podman_images.tmp"
mv "$podman_images.tmp" "$podman_images"
