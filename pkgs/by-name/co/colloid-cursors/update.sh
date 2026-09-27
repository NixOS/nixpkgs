#!/usr/bin/env nix-shell
#! nix-shell -i bash -p curl jq nix common-updater-scripts
set -euo pipefail

# check the `cursors/` directory for changes since it does not change with each upstream release

owner=vinceliuice
repo=Colloid-icon-theme
path=cursors
attr=colloid-cursors
pkg_file=./pkgs/by-name/co/colloid-cursors/package.nix

api_url_latest="https://api.github.com/repos/$owner/$repo/commits?path=$path&per_page=1"
json_latest=$(curl -sSfL -H "Accept: application/vnd.github+json" ${GITHUB_TOKEN:+-u ":$GITHUB_TOKEN"} "$api_url_latest")
latest_rev=$(printf '%s' "$json_latest" | jq -r '.[0].sha')
latest_date=$(printf '%s' "$json_latest" | jq -r '.[0].commit.committer.date' | cut -dT -f1)

if [[ -z "${latest_rev:-}" || "$latest_rev" == "null" ]]; then
  echo "Failed to fetch latest commit for path $path" >&2
  exit 1
fi

current_rev=$(nix-instantiate --eval --strict -A "$attr.src.rev" | tr -d '"')
if [[ "$latest_rev" == "$current_rev" ]]; then
  echo "$attr is already at the latest cursors commit ($latest_rev)" >&2
  echo "[]"
  exit 0
fi

new_version="0-unstable-${latest_date}"

update-source-version "$attr" "$new_version" --rev="$latest_rev" --file="$pkg_file" --ignore-same-version --print-changes
