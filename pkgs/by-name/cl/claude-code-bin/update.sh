#!/usr/bin/env nix
#!nix shell --ignore-environment .#cacert .#curl .#bash --command bash

set -euo pipefail

BASE_URL="https://storage.googleapis.com/claude-code-dist-86c565f3-f756-42ad-8dfa-d59b1c096819/claude-code-releases"

VERSION=$(curl -fsSL "$BASE_URL/latest")

curl -fsSL "$BASE_URL/$VERSION/manifest.json" --output pkgs/by-name/cl/claude-code-bin/manifest.json
