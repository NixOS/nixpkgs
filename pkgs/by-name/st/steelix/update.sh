#!/usr/bin/env nix-shell
#!nix-shell -i bash -p nix-update

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Updating steelix source to the latest commit from steel-event-system branch..."
nix-update steelix.passthru.unwrapped --version=branch=steel-event-system

echo "Fetching updated steelixSource..."
STEELIX_SRC="$(nix-instantiate --eval -A "steelix.passthru.unwrapped.src.outPath" --raw)"
GENERATE_GRAMMARS="$(nix-instantiate --eval -A "steelix.passthru.generateGrammars")"

echo "Generating grammars.json..."
"$GENERATE_GRAMMARS" \
  "$STEELIX_SRC/languages.toml" \
    -o "$SCRIPT_DIR/grammars.json"

if [ $? -ne 0 ]; then
  echo "Error: Failed to generate grammars.json" >&2
  exit 1
fi

echo "Done!"
