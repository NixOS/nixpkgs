#! /usr/bin/env nix-shell
#! nix-shell -i bash -p curl jq git gnused -I nixpkgs=.
#
# SYNOPSIS
#
#   Update Hackage index and hashes data exposed via pkgs.all-cabal-hashes.
#
# DESCRIPTION
#
#   Find latest revision of the commercialhaskell/all-cabal-hashes repository's
#   hackage branch and update pkgs/data/misc/hackage/pin.json accordingly.
#
#   This data is used by hackage2nix to generate hackage-packages.nix. Since
#   hackage2nix uses the latest version of a package unless an explicit
#   constraint is configured, running this script indirectly updates packages
#   (when hackage2nix is executed afterwards).
#
#   Prints a version difference to stdout if the pin has been updated, nothing
#   otherwise.
#
# EXIT STATUS
#
#   Always exit with zero (even if nothing changed) unless there was an error.

set -euo pipefail

if [[ "${1:-}" == "--do-commit" ]]; then
  echo "$0: --do-commit is no longer supported. Use update-package-set.sh instead."
  exit 100
fi

pin_file=pkgs/data/misc/hackage/pin.json
current_commit="$(jq -r .commit $pin_file)"
old_date="$(jq -r .msg $pin_file | sed 's/Update from Hackage at //')"
git_info="$(curl -H "Accept: application/vnd.github.v3+json" https://api.github.com/repos/commercialhaskell/all-cabal-hashes/branches/hackage)"
head_commit="$(echo "$git_info" | jq -r .commit.sha)"
commit_msg="$(echo "$git_info" | jq -r .commit.commit.message)"
new_date="$(echo "$commit_msg" | sed 's/Update from Hackage at //')"

if [ "$current_commit" != "$head_commit" ]; then
   echo "Updating all-cabal-hashes from $old_date to $new_date" >&2
   url="https://github.com/commercialhaskell/all-cabal-hashes/archive/$head_commit.tar.gz"
   hash="$(nix-prefetch-url "$url")"
   jq -n \
     --arg commit "$head_commit" \
     --arg hash "$hash" \
     --arg url "$url" \
     --arg commit_msg "$commit_msg" \
     '{commit: $commit, url: $url, sha256: $hash, msg: $commit_msg}' \
     > $pin_file
else
   echo "No new all-cabal-hashes version" >&2
   exit 0
fi

echo "$old_date -> $new_date"
