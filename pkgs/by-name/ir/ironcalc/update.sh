#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl jq common-updater-scripts nix-update

set -euo pipefail

owner="ironcalc"
repo="ironcalc"
branch="main"

commit=$(curl -s "https://api.github.com/repos/$owner/$repo/branches/$branch" | jq -r .commit.sha)
date=$(curl -s "https://api.github.com/repos/$owner/$repo/commits/$commit" | jq -r .commit.committer.date | cut -d'T' -f1)

current_version=$(nix-instantiate --eval -A ironcalc.version 2>/dev/null | tr -d '"' || echo "0.0.0")
base_version=$(echo "$current_version" | sed -E 's/-unstable-.*//')
new_version="$base_version-unstable-$date"

echo "Updating ironcalc to $new_version ($commit)"

if [ "$current_version" = "$new_version" ]; then
    echo "Already up to date: $current_version"
    exit 0
fi

update-source-version ironcalc "$new_version" --rev="$commit"

echo "Updating hashes..."

nix-update ironcalc.tools --version=skip
nix-update ironcalc.server --version=skip
nix-update ironcalc.widget --version=skip
nix-update ironcalc.frontend --version=skip
nix-update ironcalc.nodejs --version=skip
