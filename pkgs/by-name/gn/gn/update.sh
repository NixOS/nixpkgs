#!/usr/bin/env nix-shell
#!nix-shell -i bash -p git jq curl nurl

set -ex

NIXPKGS_PATH=`git rev-parse --show-toplevel`
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"

rev=`curl -L https://raw.githubusercontent.com/NixOS/nixpkgs/refs/heads/master/pkgs/applications/networking/browsers/chromium/info.json | jq -r '.chromium.deps.gn.rev'`

commit_time=`curl "https://gn.googlesource.com/gn/+/$rev?format=json" \
  | sed "s/)]}'//" \
  | jq -r ".committer.time" \
  | awk '{print $2, $3, $5, $4 $6}'`

version="0-unstable-`date -d"$commit_time" -I`"

escaped_hash=`nurl --hash --expr \
  "(import $NIXPKGS_PATH {}).gn.override { version = \"$version\"; rev = \"$rev\"; hash = \"\"; }" \
  | sed -re 's|[+]|\\&|g'`

sed -Ei \
  -e "s/(version \? ).*/\1\"$version\",/" \
  -e "s/(rev \? ).*/\1\"$rev\",/" \
  -e "s|(hash \? ).*|\1\"$escaped_hash\",|" \
  $SCRIPT_DIR/package.nix
