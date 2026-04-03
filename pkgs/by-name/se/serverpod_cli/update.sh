#!/usr/bin/env nix-shell
#!nix-shell -i bash -p coreutils jq yq-go git nix-prefetch-github common-updater-scripts dart

set -euo pipefail

PACKAGE_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
NIX_FILE="$PACKAGE_DIR/package.nix"

echo "Checking for latest serverpod version..."
latest_version=$(git ls-remote --tags https://github.com/serverpod/serverpod.git | \
    grep -v "\^{}" | \
    cut -f2 | \
    sed 's/refs\/tags\///' | \
    grep -E '^[0-9]+\.[0-9]+\.[0-9]+$' | \
    sort -V | \
    tail -n 1)

current_version=$(sed -n 's/^[[:space:]]*version = "\(.*\)";/\1/p' "$NIX_FILE")

if [[ "$latest_version" == "$current_version" ]]; then
    echo "serverpod_cli is already up to date ($current_version)"
    exit 0
fi

echo "Updating serverpod_cli from $current_version to $latest_version"

echo "Prefetching source for $latest_version..."
PREFETCH_OUT=$(nix-prefetch-github serverpod serverpod --rev "$latest_version")
echo "Prefetch output: $PREFETCH_OUT"
new_hash=$(echo "$PREFETCH_OUT" | jq -r .hash)
echo "New hash: $new_hash"

update-source-version serverpod_cli "$latest_version" "$new_hash" --version-key=version --file="$NIX_FILE"

echo "Generating fresh pubspec.lock.json..."
TMPDIR=$(mktemp -d)
trap 'rm -rf "$TMPDIR"' EXIT

src=$(nix-build --no-link . -A serverpod_cli.src)

cp -r "$src/tools/serverpod_cli/"* "$TMPDIR/"
chmod -R +w "$TMPDIR"
cd "$TMPDIR"

# Remove dependency_overrides as in the nix build
yq -i 'del(.dependency_overrides)' pubspec.yaml

# Generate lockfile because it's not included in the source
if ! test -f pubspec.lock; then
  dart pub get
fi

# Convert to JSON
yq -o=json . pubspec.lock > "$PACKAGE_DIR/pubspec.lock.json"

echo "Update complete: $current_version -> $latest_version"
