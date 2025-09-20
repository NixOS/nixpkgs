#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl jq gnused

set -euo pipefail

REV="$1"
API_BASE="https://api.github.com/repos/Suwayomi/Suwayomi-WebUI"

COMMIT_SHA="$(curl -s "$API_BASE/git/$REV" | jq -r .object.sha)"
REVISION="$(
  curl -I -s "$API_BASE"'/commits?per_page=1&sha='"$COMMIT_SHA" \
    | sed -n 's/.*"next".*page=\([0-9]*\).*"last".*/\1/p'
)"

sed -i 's/revision = "[0-9]\+"/revision = "'"$REVISION"'"/' "$(dirname "$(readlink -f "$0")")/package.nix"
