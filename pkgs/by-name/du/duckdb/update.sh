#!/usr/bin/env nix-shell
#!nix-shell -i bash -p cacert jq git moreutils nix nix-prefetch-github
# shellcheck shell=bash

set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")"

repo=duckdb
owner=duckdb

msg() {
  echo "$*" >&2
}

json_get() {
  jq -r "$1" < ./versions.json
}

json_set() {
  jq --arg x "$2" "$1 = \$x" < ./versions.json | sponge 'versions.json'
}

get_latest() {
  gh release --repo "${owner}/${repo}" list \
    --exclude-pre-releases \
    --limit 1 \
    --json tagName \
    --jq '.[].tagName'
}

tag="$(get_latest | sed 's/^v//g')"

json=$(nix-prefetch-github "${owner}" "${repo}" --rev "v${tag}")

json_set ".version" "${tag}"
json_set ".rev" "$(jq -r '.rev' <<< "${json}")"
json_set ".hash" "$(jq -r '.hash' <<< "${json}")"
