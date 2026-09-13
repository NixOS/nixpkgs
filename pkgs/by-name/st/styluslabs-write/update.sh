#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl jq common-updater-scripts

set -euo pipefail

PACKAGE=styluslabs-write
GITHUB_API=https://api.github.com

log() { echo >&2 "$@"; }

package_attr() {
  nix-instantiate --eval --json --attr "$PACKAGE.$1" | jq -r .
}

github_api() {
  local path=$1
  local token_header=()
  if [[ -n "${GITHUB_TOKEN:-}" ]]; then
    token_header=(-H "Authorization: Bearer $GITHUB_TOKEN")
  fi
  curl -sSf "${token_header[@]}" "$GITHUB_API$path"
}

owner=$(package_attr src.owner)
repo=$(package_attr src.repo)
old_version=$(package_attr version)
old_rev=$(package_attr src.rev)
log "Current version: $old_version ($old_rev)"

latest_release_json=$(github_api "/repos/$owner/$repo/releases/latest")
tag=$(jq -r '.tag_name' <<<"$latest_release_json")
if [[ -z "$tag" || "$tag" == "null" ]]; then
  log "Error: could not find tag_name in GitHub release response."
  exit 1
fi

commit_json=$(github_api "/repos/$owner/$repo/commits/$tag")
new_rev=$(jq -r '.sha' <<<"$commit_json")
date=$(jq -r '.commit.committer.date' <<<"$commit_json")
new_version=$(date -u -d "$date" +%Y-%m-%d)
if [[ "$old_version" == "$new_version" ]]; then
  log "No update needed (still at $new_version)"
  exit 0
fi
log "Updating to version $new_version ($new_rev)"

update-source-version "$PACKAGE" "$new_version" --rev="$new_rev"
