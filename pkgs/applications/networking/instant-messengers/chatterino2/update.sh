#!/usr/bin/env nix-shell
#!nix-shell -I nixpkgs=./. -i bash -p curl common-updater-scripts jq

set -euo pipefail

ATTR=$1

OLD_VERSION=$(nix eval --raw -f default.nix "$ATTR.version")
OWNER=$(nix eval --raw -f default.nix "$ATTR.src.owner")
REPO=$(nix eval --raw -f default.nix "$ATTR.src.repo")

if [[ $OLD_VERSION =~ "0-unstable-" ]]; then
    releaseDate=$(curl "https://api.github.com/repos/$OWNER/$REPO/commits/nightly-build" | jq -r '.commit.author.date' | cut -d 'T' -f 1)
    revision=$(curl "https://api.github.com/repos/$OWNER/$REPO/commits/nightly-build" | jq -r '.sha')
    version="0-unstable-$releaseDate"
    update-source-version "$ATTR" "$version" --rev="$revision"
else
    version=$(curl --silent "https://api.github.com/repos/$OWNER/$REPO/releases" | jq -r '[.[] | select(.tag_name != "nightly-build")] | .[0].tag_name' | sed 's/v//')
    update-source-version "$ATTR" "$version"
fi
