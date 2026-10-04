#!/usr/bin/env nix-shell
#!nix-shell -i bash -p bash common-updater-scripts coreutils git gnugrep gnused nix

set -euo pipefail

attr=proton-drive-cli
pkgDir=$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")
nixpkgs=$(readlink -f "$pkgDir/../../../..")
cd "$nixpkgs"

tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT

git clone --quiet --bare --filter=blob:none https://github.com/ProtonDriveApps/sdk.git "$tmp/sdk.git"

latestTag() {
  git -C "$tmp/sdk.git" tag --list "$1/v*" --sort=-v:refname "${@:2}" \
    | grep -E "^$1/v[0-9]+\.[0-9]+\.[0-9]+$" \
    | head -n1 || true
}

oldVersion=$(nix-instantiate --eval --raw -A "$attr.version")
cliTag=$(latestTag cli)
[[ -n "$cliTag" ]] || { echo "error: no cli/v* tag found" >&2; exit 1; }
version=${cliTag#cli/v}

if [[ "$oldVersion" == "$version" ]]; then
  echo "$attr is already up to date at $version"
  exit 0
fi

# The build embeds the latest js SDK release contained in the cli release.
jsTag=$(latestTag js --merged "$cliTag")
[[ -n "$jsTag" ]] || { echo "error: no js/v* tag merged into $cliTag" >&2; exit 1; }
jsVersion=${jsTag#js/v}

update-source-version "$attr" "$version"
sed -i "s|jsVersion = \".*\";|jsVersion = \"$jsVersion\";|" "$pkgDir/package.nix"

# node_modules differ between Linux and Darwin, so each hash has to be
# computed on (or with a remote builder for) the respective platform.
fakeHash="sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA="
for system in x86_64-linux aarch64-darwin; do
  oldHash=$(nix-instantiate --eval --raw --system "$system" -A "$attr.nodeModules.outputHash")
  sed -i "s|\"$oldHash\"|\"$fakeHash\"|" "$pkgDir/package.nix"

  output=$(nix-build --no-out-link --system "$system" -A "$attr.nodeModules" 2>&1 || true)
  newHash=$(sed -n 's/.*got: *\(sha256-[A-Za-z0-9+/=]*\).*/\1/p' <<<"$output")

  if [[ -n "$newHash" ]]; then
    sed -i "s|\"$fakeHash\"|\"$newHash\"|" "$pkgDir/package.nix"
  else
    sed -i "s|\"$fakeHash\"|\"$oldHash\"|" "$pkgDir/package.nix"
    echo "warning: could not compute nodeModules hash for $system, please update it manually" >&2
    tail -n 5 <<<"$output" >&2
  fi
done
