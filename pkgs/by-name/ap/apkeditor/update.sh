#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl jq common-updater-scripts

set -euo pipefail

GITHUB_TOKEN="${GITHUB_TOKEN:-}"

nixpkgs_attr() {
  nix-instantiate --eval --raw --attr "$1"
}

github_api() {
  local token_opt=()
  if [[ -n "$GITHUB_TOKEN" ]]; then
    token_opt=(-H "Authorization: Bearer $GITHUB_TOKEN")
  fi
  curl -fsS "${token_opt[@]}" "https://api.github.com$1"
}

update_mitm_cache() {
  if [[ -z "$(nixpkgs_attr "$1.mitmCache.name")" ]]; then
    return
  fi
  "$(nix-build -A "$1.mitmCache.updateScript")"
}

update() {
  echo "Updating $1..." >&2

  local owner="$(nixpkgs_attr "$1.src.owner")"
  local repo="$(nixpkgs_attr "$1.src.repo")"

  local old_version="$(nixpkgs_attr "$1.version")"
  local use_last_commit=0
  if [[ "$old_version" == *unstable* ]]; then
    use_last_commit=1
  fi

  if (( use_last_commit )); then
    local repo_info="$(github_api "/repos/$owner/$repo/commits?per_page=1" | jq ".[0]")"
    local new_rev="$(echo "$repo_info" | jq -r .sha)"
    local date="$(echo "$repo_info" | jq -r .commit.author.date)"
    date="$(date -u -d "$date" +%Y-%m-%d)"
    local new_version="${old_version%%-unstable*}-unstable-$(date -u -d "$date" +%Y-%m-%d)"
    update-source-version "$1" "$new_version" --rev="$new_rev" --ignore-same-version --ignore-same-hash
  else
    local tag="$(github_api "/repos/$owner/$repo/releases/latest" | jq -r .tag_name)"
    local new_version="${tag#V}"
    update-source-version "$1" "$new_version" --ignore-same-version --ignore-same-hash
  fi

  update_mitm_cache "$1"
}

update apkeditor.passthru.deps.arsclib
update apkeditor.passthru.deps.smali
update apkeditor.passthru.deps.jcommand
update apkeditor
