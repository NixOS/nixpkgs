#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl jq common-updater-scripts

set -euo pipefail

version="$(
    curl -s https://api.github.com/repos/ztefn/haguichi/releases |
    jq '.[] | select(.target_commitish!="elementary") | .tag_name' --raw-output |
    sort --version-sort --reverse |
    head -n1
)"

update-source-version haguichi "$version"
