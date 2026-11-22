#!/usr/bin/env nix-shell
#! nix-shell -i bash -p curl jq common-updater-scripts
set -euo pipefail

owner=freebsd
repo=freebsd-src
path=contrib/ee
pkg_file=./pkgs/by-name/ee/ee/package.nix

api_url_latest="https://api.github.com/repos/$owner/$repo/commits?path=$path&per_page=1"
json_latest=$(curl -sSfL -H "Accept: application/vnd.github+json" ${GITHUB_TOKEN:+-u ":$GITHUB_TOKEN"} "$api_url_latest")
latest_rev=$(printf '%s' "$json_latest" | jq -r '.[0].sha')
latest_date=$(printf '%s' "$json_latest" | jq -r '.[0].commit.committer.date' | cut -dT -f1)

if [[ -z "${latest_rev:-}" || "$latest_rev" == "null" ]]; then
  echo "Failed to fetch latest commit for path $path" >&2
  exit 1
fi

# Fetch EE_VERSION from that commit
raw_url="https://raw.githubusercontent.com/$owner/$repo/$latest_rev/$path/ee_version.h"
ee_version=$(curl -sSfL ${GITHUB_TOKEN:+-u ":$GITHUB_TOKEN"} "$raw_url" | sed -n 's/^#define[[:space:]]*EE_VERSION[[:space:]]*"\([^"]*\)".*/\1/p')
if [[ -z "${ee_version:-}" ]]; then
  echo "Failed to parse EE_VERSION from ee_version.h at $latest_rev" >&2
  exit 1
fi

new_version="${ee_version}-unstable-${latest_date}"

update-source-version ee "$new_version" --rev="$latest_rev" --file="$pkg_file" --ignore-same-version --print-changes
