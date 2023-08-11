#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl coreutils jq common-updater-scripts

set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")"

DECK_LATEST_VERSION=$(curl -s "https://api.github.com/repos/kong/deck/releases?per_page=1" | jq -r '.[0].name')
CURRENT_VERSION=v$(sed -nE 's/\s*version = "(.*)".*/\1/p' ./default.nix)

if [[ "$DECK_LATEST_VERSION" == "$CURRENT_VERSION" ]]; then
  echo "Already up to date!"
  exit 0
fi

CURRENT_HASH=$(sed -nE 's/\s*short_hash = "(.*)".*/\1/p' ./default.nix)
NEW_HASH=$(curl -s https://api.github.com/repos/kong/deck/tags | jq -rc '.[] | select(.name=="$DECK_LATEST_VERSION")|.commit.sha' | head -c 7 -)

sed -i "s|$CURRENT_HASH|$NEW_HASH|" "./default.nix"

update-source-version deck "${DECK_LATEST_VERSION//v/}"
