#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl common-updater-scripts jq

set -eu -o pipefail

oldVersion="$(nix-instantiate --eval -E "with import ./. {}; lib.getVersion git" | tr -d '"')"
latestTag="$(git ls-remote --tags --sort="v:refname" git://github.com/git/git.git | grep -v '\{\}' | grep -v '\-rc' | tail -1 | sed 's|^.*/v\(.*\)|\1|')"

if [ ! "${oldVersion}" = "${latestTag}" ]; then
  update-source-version git "${latestTag}"
  nixpkgs="$(git rev-parse --show-toplevel)"
  default_nix="$nixpkgs/pkgs/applications/version-management/git-and-tools/git/default.nix"
  nix-build -A git
  git add "${default_nix}"
  git commit -m "git: ${oldVersion} -> ${latestTag}"
else
  echo "git is already up-to-date"
fi
