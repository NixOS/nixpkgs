#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl jq common-updater-scripts

set -euo pipefail

PACKAGE=styluslabs-write-bin
GITHUB_REPO=styluslabs/Write
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

old_version=$(package_attr version)
log "Current version: $old_version"

latest_release_json=$(github_api "/repos/$GITHUB_REPO/releases/latest")
tag=$(jq -r '.tag_name' <<<"$latest_release_json")
if [[ -z "$tag" || "$tag" == "null" ]]; then
  log "Error: could not find tag_name in GitHub release response."
  exit 1
fi

rev=$(github_api "/repos/$GITHUB_REPO/git/ref/tags/$tag" | jq -r '.object.sha')
if [[ -z "$rev" || "$rev" == "null" ]]; then
  log "Error: could not find object.sha for tag $tag."
  exit 1
fi

commit_json=$(github_api "/repos/$GITHUB_REPO/git/commits/$rev")
date=$(jq -r '.commit.author.date // .author.date' <<<"$commit_json")
if [[ -z "$date" || "$date" == "null" ]]; then
  log "Error: could not find commit date."
  exit 1
fi
new_version=$(date -u -d "$date" +%Y-%m-%d)
if [[ "$old_version" == "$new_version" ]]; then
  log "No update needed (still at $new_version)"
  exit 0
fi

new_url=$(jq -r '.assets[]?.browser_download_url | select(endswith(".tar.gz"))' <<<"$latest_release_json" | head -n1)
if [[ -z "$new_url" || "$new_url" == "null" ]]; then
  log "Error: no .tar.gz asset found in release $tag"
  exit 1
fi

log "Latest version: $new_version (tag $tag)"
log "Source URL: $new_url"

update-source-version "$PACKAGE" "$new_version" "" "$new_url"
