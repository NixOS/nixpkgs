#!/usr/bin/env nix-shell
#!nix-shell -i bash -p nodejs nix-update jq curl
set -euo pipefail

cd "$(dirname "${BASH_SOURCE[0]}")"

version=$(npm view cf version)

tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT

# Regenerate the lockfile from the published tarball. devDependencies are
# dropped because they reference vendored tarballs that are not published.
curl -sSL "https://registry.npmjs.org/cf/-/cf-$version.tgz" | tar xz -C "$tmp"
jq 'del(.devDependencies)' "$tmp/package/package.json" > "$tmp/package.json"
(cd "$tmp" && npm install --package-lock-only --ignore-scripts --no-audit --no-fund)
cp "$tmp/package-lock.json" package-lock.json

cd - > /dev/null
nix-update cf --version "$version"
