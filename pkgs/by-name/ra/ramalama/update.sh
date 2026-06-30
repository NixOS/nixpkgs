#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl jq nix-prefetch-docker nix-update nixfmt

set -euo pipefail

cd "$(git rev-parse --show-toplevel)"

dir="pkgs/by-name/ra/ramalama"
podman_images="$dir/tests/podman-images.json"

version="${1:-}"
if [[ -z "$version" ]]; then
  curl_args=(-fsSL)
  if [[ -n "${GITHUB_TOKEN:-}" ]]; then
    curl_args+=(-u ":$GITHUB_TOKEN")
  fi
  version="$(
    curl "${curl_args[@]}" "https://api.github.com/repos/containers/ramalama/releases/latest" \
      | jq -r '.tag_name | sub("^v"; "")'
  )"
fi
version="${version#v}"

IFS=. read -r major minor _rest <<<"$version"
if [[ -z "${major:-}" || -z "${minor:-}" ]]; then
  echo "Could not derive RamaLama image tag from version: $version" >&2
  exit 1
fi

image_name="quay.io/ramalama/ramalama"
image_tag="$major.$minor"

prefetch_image() {
  local arch="$1"
  nix-prefetch-docker \
    --json \
    --quiet \
    --os linux \
    --arch "$arch" \
    --image-name "$image_name" \
    --image-tag "$image_tag"
}

amd64_image="$(prefetch_image amd64)"
arm64_image="$(prefetch_image arm64)"

amd64_digest="$(jq -r '.imageDigest' <<<"$amd64_image")"
arm64_digest="$(jq -r '.imageDigest' <<<"$arm64_image")"
if [[ "$amd64_digest" != "$arm64_digest" ]]; then
  echo "Expected $image_name:$image_tag to resolve to one multi-arch digest, got:" >&2
  echo "  amd64: $amd64_digest" >&2
  echo "  arm64: $arm64_digest" >&2
  exit 1
fi

nix-update ramalama --version "$version"

jq \
  --null-input \
  --arg imageName "$image_name" \
  --arg imageTag "$image_tag" \
  --arg imageDigest "$amd64_digest" \
  --arg amd64Hash "$(jq -r '.hash' <<<"$amd64_image")" \
  --arg arm64Hash "$(jq -r '.hash' <<<"$arm64_image")" \
  '{
    imageName: $imageName,
    imageTag: $imageTag,
    imageDigest: $imageDigest,
    images: {
      "x86_64-linux": {
        arch: "amd64",
        hash: $amd64Hash
      },
      "aarch64-linux": {
        arch: "arm64",
        hash: $arm64Hash
      }
    }
  }' >"$podman_images.tmp"
mv "$podman_images.tmp" "$podman_images"

nixfmt "$dir/package.nix"
