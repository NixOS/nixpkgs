#!/usr/bin/env bash

# Requests reviews for a PR

set -euo pipefail
tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' exit
SCRIPT_DIR=$(dirname "$0")

log() {
    echo "$@" >&2
}

if (( $# < 3 )); then
    log "Usage: $0 GITHUB_REPO PR_NUMBER OWNERS_FILE"
    exit 1
fi
baseRepo=$1
prNumber=$2
ownersFile=$3

log "Fetching PR info"
prInfo=$(gh api \
  -H "Accept: application/vnd.github+json" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  "/repos/$baseRepo/pulls/$prNumber")

baseBranch=$(jq -r .base.ref <<< "$prInfo")
log "Base branch: $baseBranch"
prRepo=$(jq -r .head.repo.full_name <<< "$prInfo")
log "PR repo: $prRepo"
prBranch=$(jq -r .head.ref <<< "$prInfo")
log "PR branch: $prBranch"
prAuthor=$(jq -r .user.login <<< "$prInfo")
log "PR author: $prAuthor"

extraArgs=()
if pwdRepo=$(git rev-parse --show-toplevel 2>/dev/null); then
    # Speedup for local runs
    extraArgs+=(--reference-if-able "$pwdRepo")
fi

log "Fetching Nixpkgs commit history"
# We only need the commit history, not the contents, so we can do a tree-less clone using tree:0
# https://github.blog/open-source/git/get-up-to-speed-with-partial-clone-and-shallow-clone/#user-content-quick-summary
git clone --bare --filter=tree:0 --no-tags --origin upstream "${extraArgs[@]}" https://github.com/"$baseRepo".git "$tmp"/nixpkgs.git

log "Fetching the PR commit history"
# Fetch the PR
git -C "$tmp/nixpkgs.git" remote add fork https://github.com/"$prRepo".git
# This remote config is the same as --filter=tree:0 when cloning
git -C "$tmp/nixpkgs.git" config remote.fork.partialclonefilter tree:0
git -C "$tmp/nixpkgs.git" config remote.fork.promisor true

git -C "$tmp/nixpkgs.git" fetch --no-tags fork "$prBranch"
headRef=$(git -C "$tmp/nixpkgs.git" rev-parse refs/remotes/fork/"$prBranch")

log "Requesting reviews from code owners"
"$SCRIPT_DIR"/get-code-owners.sh "$tmp/nixpkgs.git" "$ownersFile" "$baseBranch" "$headRef" | \
    "$SCRIPT_DIR"/request-reviewers.sh "$baseRepo" "$prNumber" "$prAuthor"
