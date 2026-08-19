#!/usr/bin/env nix-shell
#! nix-shell -p curl jq common-updater-scripts
#! nix-shell -i bash

set -euo pipefail

release="$(
  curl -s -f \
    ${GITHUB_TOKEN:+-u ":$GITHUB_TOKEN"} \
    "https://api.github.com/repos/Try/OpenGothic/releases?per_page=1" |
    jq -r 'first | {version: .name, tag: .tag_name}'
)"
version="$(jq -r .version <<<"$release")"
tag="$(jq -r .tag <<<"$release")"

update-source-version opengothic "${version//opengothic-v/}" \
  --file=pkgs/by-name/op/opengothic/package.nix \
  --rev="refs/tags/$tag" \
  --print-changes
