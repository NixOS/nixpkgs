#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl jq common-updater-scripts nix-update
# shellcheck shell=bash

# Buzz Desktop releases (desktop-v* tags) ship the CLI, which has no releases of
# its own (https://github.com/block/buzz/issues/8553). Mobile releases tag the
# same repository far more often, so GitHub's release feed, which nix-update
# reads, rarely shows a desktop release: list the releases through the API.
# The other Buzz packages inherit the source, version and Cargo hash from
# buzz-cli; buzz-desktop has its own Cargo and pnpm hashes.

set -euo pipefail

cd "$(git rev-parse --show-toplevel)"

tag="$(curl -sSfL ${GITHUB_TOKEN:+-u ":$GITHUB_TOKEN"} "https://api.github.com/repos/block/buzz/releases?per_page=100" |
  jq -r '[.[] | select((.draft or .prerelease) | not) | .tag_name | select(test("^desktop-v[0-9.]+$"))][0]')"

update-source-version buzz-cli "${tag#desktop-v}"
nix-update buzz-cli --version skip
nix-update buzz-desktop --version skip
