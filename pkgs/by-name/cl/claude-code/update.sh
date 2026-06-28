#!/usr/bin/env nix-shell
#!nix-shell -i bash -p bash curl jq

set -euo pipefail

cd "$(dirname "${BASH_SOURCE[0]}")"

BASE_URL="https://downloads.claude.ai/claude-code-releases"

VERSION="${1:-$(curl -fsSL "https://registry.npmjs.org/@anthropic-ai/claude-code/latest" | jq -r '.version')}"

curl -fsSL "$BASE_URL/$VERSION/manifest.json" --output manifest.json
