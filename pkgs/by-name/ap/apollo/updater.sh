#!/usr/bin/env bash
# Refresh the apollo derivation to the latest GitHub release tag.
set -euo pipefail
cd "$(dirname "$0")"

TAG="$(curl -fsSL https://api.github.com/repos/MrOz59/Hermes/releases/latest | grep -oP '"tag_name":\s*"v\K[^"]+')
TAG="v${TAG}"
echo "latest tag: $TAG"

# fetchFromGitHub with tag= uses the API tarball endpoint
URL="https://api.github.com/repos/MrOz59/Hermes/tarball/${TAG}"
HASH="$(nix-prefetch-url "$URL" | tail -1)"

sed -i "s/^  version = .*/  version = \"${TAG#v}\";/" package.nix
sed -i "s/^    hash = .*/    hash = \"sha256-${HASH}\";/" package.nix

echo "updated package.nix to ${TAG}"
echo "verify: nix build .#apollo"
echo "NOTE: if the web UI changed upstream, regenerate package-lock.json"
echo "      (npm install in a clean copy of the source) and update npmDepsHash."
