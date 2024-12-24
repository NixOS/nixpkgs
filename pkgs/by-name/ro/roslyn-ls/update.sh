#! /usr/bin/env nix-shell
#! nix-shell -I nixpkgs=./. -i bash -p curl jq common-updater-scripts
# shellcheck shell=bash

set -euo pipefail

cd "$(dirname "${BASH_SOURCE[0]}")"

old_vs_version="$(sed -nE 's/\s*vsVersion = "(.*)".*/\1/p' ./package.nix)"
new_vs_version="$(curl -s "https://api.github.com/repos/dotnet/vscode-csharp/tags?per_page=1" | jq -r '.[0].name' | sed 's/v//')"

if [[ "$new_vs_version" == "$old_vs_version" ]]; then
    echo "Already up to date!"
    exit 0
fi

old_roslyn_version="$(sed -nE 's/\s*version = "(.*)".*/\1/p' ./package.nix)"
new_roslyn_version="$(curl -s "https://raw.githubusercontent.com/dotnet/vscode-csharp/v$new_vs_version/package.json" | jq -r .defaults.roslyn)"

sed -i "s/ = \"${old_roslyn_version}\"/ = \"${new_roslyn_version}\"/" ./package.nix

cd ../../../..
update-source-version roslyn-ls "${new_vs_version}" --version-key=vsVersion

$(nix-build -A roslyn-ls.fetch-deps --no-out-link)
