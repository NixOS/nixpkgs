#!/usr/bin/env nix-shell
#!nix-shell -i bash -p yq nix bash coreutils nix-update common-updater-scripts ripgrep flutter

set -eou pipefail

PACKAGE_DIR="$(realpath "$(dirname "$0")")"
cd "$PACKAGE_DIR"/..
while ! test -f flake.nix; do cd ..; done
NIXPKGS_DIR="$PWD"

latestVersion=$(
    list-git-tags --url=https://github.com/sun-jiao/flut-renamer |
        rg '^v(.*)' -r '$1' |
        sort --version-sort |
        tail -n1
)

currentVersion=$(nix-instantiate --eval -E "with import ./. {}; flut-renamer.version or (lib.getVersion flut-renamer)" | tr -d '"')

if [[ "$currentVersion" == "$latestVersion" ]]; then
    echo "package is up-to-date: $currentVersion"
    exit 0
fi

nix-update --version=$latestVersion flut-renamer

export HOME="$(mktemp -d)"
src="$(nix-build --no-link "$NIXPKGS_DIR" -A flut-renamer.src)"
TMPDIR="$(mktemp -d)"
cp --recursive --no-preserve=mode "$src"/* $TMPDIR
cd $TMPDIR
flutter pub get
yq . pubspec.lock >"$PACKAGE_DIR"/pubspec.lock.json
rm -rf $TMPDIR
