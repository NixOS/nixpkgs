#!/usr/bin/env nix
#!nix shell --ignore-environment .#cacert .#coreutils .#curl .#bash --command bash

set -euo pipefail

cd "$(dirname "${BASH_SOURCE[0]}")"

BASE_URL="https://downloads.claude.ai/claude-code-releases"

VERSION="${1:-$(curl -fsSL "$BASE_URL/latest")}"

curl -fsSL "$BASE_URL/$VERSION/manifest.json" --output manifest.json
