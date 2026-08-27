#!/usr/bin/env nix-shell
#!nix-shell -i bash -p bash gnused nix nix-update
set -euo pipefail

attr=proton-drive-cli
pkgDir=$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")
oldVersion=$(nix-instantiate --eval --raw -A "$attr.version")
nix-update "$attr" --version-regex 'cli/v(.*)' --custom-dep nodeModules
newVersion=$(nix-instantiate --eval --raw -A "$attr.version")

if [[ "$oldVersion" == "$newVersion" ]]; then
  exit 0
fi

# The build embeds the latest js SDK release contained in the cli release.
src=$(nix-build --no-out-link -A "$attr.src")
jsVersion=$(sed -n 's|^## js/v\([0-9.]*\) .*|\1|p' "$src/client/js/CHANGELOG.md" | head -n1)
sed -i "s|jsVersion = \".*\";|jsVersion = \"$jsVersion\";|" "$pkgDir/package.nix"
