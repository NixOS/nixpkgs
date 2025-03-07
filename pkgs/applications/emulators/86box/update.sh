#!/usr/bin/env nix-shell
#!nix-shell -i bash -p jq nix-prefetch-github common-updater-scripts

set -euo pipefail

latest_release=$(curl --silent https://api.github.com/repos/86Box/86Box/releases/latest)
version=$(jq -r '.tag_name' <<<"$latest_release" | cut -c2-)
main_hash=$(nix-prefetch-github --json --rev "v$version" 86Box 86Box | jq -r '.hash')
roms_hash=$(nix-prefetch-github --json --rev "v$version" 86Box roms | jq -r '.hash')

update-source-version _86Box "_$version" "$main_hash"
update-source-version _86Box "$version" "$roms_hash" --source-key=roms
