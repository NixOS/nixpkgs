#!/usr/bin/env nix-shell
#!nix-shell -i bash -p jq curl common-updater-scripts

set -ex

rev=$(
  curl --location "https://raw.githubusercontent.com/NixOS/nixpkgs/refs/heads/master/pkgs/applications/networking/browsers/chromium/info.json" \
  | jq -r ".chromium.deps.gn.rev"
)

commit_time=$(
  curl "https://gn.googlesource.com/gn/+/$rev?format=json" \
  | sed "s/)]}'//" \
  | jq -r ".committer.time" \
  | awk '{print $2, $3, $5, $4 $6}'
)

commit_date=$(TZ= date --date "$commit_time" --iso-8601)
version="0-unstable-$commit_date"

update-source-version --rev="$rev" --version-key="_version" "gn" "$version"
