#!/usr/bin/env nix-shell
#! nix-shell -i bash -p common-updater-scripts coreutils curl git jq nix-update
# shellcheck shell=bash
set -euo pipefail

# Upstream publishes each release as a commit on the default branch without
# pushing a tag, so the version is read from package.json at that commit.

attr=${UPDATE_NIX_ATTR_PATH:-proton-lumo}
repo=ProtonLumo/lumo-desktop

rev=$(git ls-remote "https://github.com/$repo.git" HEAD | cut -f1)
version=$(curl --fail --silent --show-error \
  "https://raw.githubusercontent.com/$repo/$rev/package.json" | jq -r .version)
old_version=${UPDATE_NIX_OLD_VERSION:-$(nix-instantiate --eval --json -A "$attr.version" | jq -r .)}

if [[ ! $version =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
  echo "unexpected upstream version '$version'" >&2
  exit 1
fi

if [[ $(printf '%s\n' "$old_version" "$version" | sort -V | tail -n1) == "$old_version" ]]; then
  echo "$attr is already at $old_version (upstream: $version)"
  exit 0
fi

update-source-version "$attr" "$version" --rev="$rev"
nix-update "$attr" --version=skip --no-src
