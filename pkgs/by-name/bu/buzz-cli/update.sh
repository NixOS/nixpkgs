#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl jq nix-update
# shellcheck shell=bash

# buzz-relay builds the same source with the same cargoHash, so it has to move
# in the same step as buzz-cli: its own version and web bundle hash follow here.

set -euo pipefail

cd "$(git rev-parse --show-toplevel)"

# Mobile releases tag the same repository far more often, so the release feed
# nix-update reads by default rarely shows a desktop release.
nix-update buzz-cli --use-github-releases --version-regex '^desktop-v(\d+\.\d+\.\d+)$'

tag="desktop-v$(nix-instantiate --eval --raw -A buzz-cli.version)"
# The relay builds that release under its own (unreleased) crate version.
date="$(curl -sSfL ${GITHUB_TOKEN:+-u ":$GITHUB_TOKEN"} "https://api.github.com/repos/block/buzz/commits/$tag" | jq -er .commit.committer.date | cut -dT -f1)"
relay="$(curl -sSfL "https://raw.githubusercontent.com/block/buzz/$tag/crates/buzz-relay/Cargo.toml" | sed -n 's/^version = "\(.*\)"$/\1/p' | head -n 1)"
[ -n "$relay" ]
sed -i "s|^  version = \".*-unstable-.*\";|  version = \"$relay-unstable-$date\";|" pkgs/by-name/bu/buzz-relay/package.nix
# The relay's web bundles have their own pnpm dependency hash.
nix-update buzz-relay --version skip --subpackage web
