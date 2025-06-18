#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl common-updater-scripts jq git

set -eu -o pipefail

oldVersion="$(nix-instantiate --eval -E "with import ./. {}; lib.getVersion git" | tr -d '"')"
latestTag="$(git ls-remote --tags --sort="v:refname" https://github.com/git/git.git | grep -v '{}' | grep -v '\-rc' | tail -1 | sed 's|^.*/v\(.*\)|\1|')"
targetVersion="${1:-$latestTag}"

if [ ! "${oldVersion}" = "${targetVersion}" ]; then
  update-source-version git "${targetVersion}"
  nixpkgs="$(git rev-parse --show-toplevel)"
  default_nix="$nixpkgs/pkgs/applications/version-management/git/default.nix"
  nix-build -A git
  git add "${default_nix}"
  git commit -m "git: ${oldVersion} -> ${targetVersion}"
else
  echo "git is already up-to-date"
fi
