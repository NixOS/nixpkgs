#!/usr/bin/env nix-shell
#!nix-shell -i bash -p yq nix bash coreutils nix-update common-updater-scripts ripgrep flutter

set -eou pipefail

PACKAGE_DIR="$(realpath "$(dirname "$0")")"
cd "$PACKAGE_DIR"/..
while ! test -f flake.nix; do cd ..; done
NIXPKGS_DIR="$PWD"

latestVersion=$(
    list-git-tags --url=https://github.com/xiaoyaocz/dart_simple_live |
        rg '^v(.*)' -r '$1' |
        sort --version-sort |
        tail -n1
)

currentVersion=$(nix-instantiate --eval -E "with import ./. {}; simple-live-app.version or (lib.getVersion simple-live-app)" | tr -d '"')

if [[ "$currentVersion" == "$latestVersion" ]]; then
    echo "package is up-to-date: $currentVersion"
    exit 0
fi

nix-update --version=$latestVersion simple-live-app

export HOME="$(mktemp -d)"
src="$(nix-build --no-link "$NIXPKGS_DIR" -A simple-live-app.src)"
TMPDIR="$(mktemp -d)"
cp --recursive --no-preserve=mode "$src"/* $TMPDIR
cd "$TMPDIR"/simple_live_app
flutter pub get
yq . pubspec.lock >"$PACKAGE_DIR"/pubspec.lock.json
rm -rf $TMPDIR
