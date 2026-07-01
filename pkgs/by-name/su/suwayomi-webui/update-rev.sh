#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl jq gnused

set -euo pipefail

TAG="$(grep -oP 'version = "\K[\d\.]+' "$1/package.nix")"

COMMIT_SHA="$(
  curl -s ${GITHUB_TOKEN:+-u ":$GITHUB_TOKEN"} "https://api.github.com/repos/Suwayomi/Suwayomi-WebUI/git/ref/tags/v$TAG" \
    | jq -r .object.sha
)"
REVISION="$(
  curl -I -s ${GITHUB_TOKEN:+-u ":$GITHUB_TOKEN"} 'https://api.github.com/repos/Suwayomi/Suwayomi-WebUI/commits?per_page=1&sha='"$COMMIT_SHA" \
    | sed -n 's/.*"next".*page=\([0-9]*\).*"last".*/\1/p'
)"

sed -i 's/revision = "[0-9]\+"/revision = "'"$REVISION"'"/' "$1/package.nix"
