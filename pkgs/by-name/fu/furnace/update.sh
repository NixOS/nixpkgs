#!/usr/bin/env nix-shell
#!nix-shell -i bash -p common-updater-scripts curl jql

set -eu -o pipefail

# Because upstream uses release tags that don't always sort correctly, query for latest release
version="$(
  curl -Ls 'https://api.github.com/repos/tildearrow/furnace/releases/latest' \
  | jql -r '"tag_name"' \
  | sed 's/^v//'
)"
update-source-version furnace "$version"
