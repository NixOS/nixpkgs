#!/usr/bin/env nix-shell
#!nix-shell -i bash -p nurl nix-update python3

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PACKAGE="${1:-helix}"

case "$PACKAGE" in
  helix)
    nix-update helix-unwrapped
    SOURCE_ATTR="helix-unwrapped.src.outPath"
    GRAMMARS_JSON="pkgs/by-name/he/helix/grammars.json"
    ;;
  steelix)
    nix-update steelix.unwrapped --version=branch=steel-event-system
    SOURCE_ATTR="steelix.unwrapped.src.outPath"
    GRAMMARS_JSON="pkgs/by-name/st/steelix/grammars.json"
    ;;
  *)
    exit 1
    ;;
esac

echo "Fetching updated $PACKAGE source..."
HELIX_SRC=$(nix-instantiate --eval -A "$SOURCE_ATTR" --raw)

echo "Generating grammars.json..."
"$SCRIPT_DIR/generate_grammars.py" \
  "$HELIX_SRC/languages.toml" \
  -o "$GRAMMARS_JSON"

if [ $? -ne 0 ]; then
  echo "Error: Failed to generate grammars.json" >&2
  exit 1
fi

echo "Done! Updated $GRAMMARS_JSON"
