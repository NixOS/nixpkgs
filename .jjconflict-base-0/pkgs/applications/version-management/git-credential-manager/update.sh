#!/usr/bin/env nix-shell
#!nix-shell -I nixpkgs=./. -i bash -p curl jq common-updater-scripts
set -eo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")"

new_version="$(curl -s "https://api.github.com/repos/git-ecosystem/git-credential-manager/releases?per_page=1" | jq -r '.[0].name' | sed 's|^GCM ||')"
old_version="$(sed -nE 's/\s*version = "(.*)".*/\1/p' ./default.nix)"
if [[ "$new_version" == "$old_version" ]]; then
  echo "Up to date"
  exit 0
fi

cd ../../../..
update-source-version git-credential-manager "$new_version"
$(nix-build -A git-credential-manager.fetch-deps --no-out-link)
