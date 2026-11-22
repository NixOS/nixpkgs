#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl jq nix-update yarn-berry_4.yarn-berry-fetcher

set -euo pipefail

# Get the latest tag from gitlab
LATEST_TAG=$(curl -s https://dev.funkwhale.audio/api/v4/projects/funkwhale%2Ffunkwhale/repository/tags | jq -r '.[0].name')

echo "Updating to $LATEST_TAG"

# Update main package version and hash
nix-update funkwhale --version="$LATEST_TAG"

# We might be running from nixpkgs root or package directory. Find the nixpkgs root.
NIXPKGS_ROOT=$(git rev-parse --show-toplevel)

# Fetch new yarn hashes
echo "Fetching yarn hashes..."
yarn-berry-fetcher missing-hashes $(nix-build "$NIXPKGS_ROOT" -A funkwhale.frontend.src --no-out-link)/front/yarn.lock > "$NIXPKGS_ROOT/pkgs/by-name/fu/funkwhale/missing-hashes.json"

# Update frontend offlineCache hash
nix-update funkwhale --version="$LATEST_TAG" --subpackage frontend
