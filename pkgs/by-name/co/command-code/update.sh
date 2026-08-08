#!/usr/bin/env nix-shell
#!nix-shell -i bash -p nodejs jq nix-update

set -euo pipefail

package_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
temporary_dir="$(mktemp -d)"
trap 'rm -rf "$temporary_dir"' EXIT

version="$(npm view command-code version)"
npm pack --ignore-scripts --pack-destination "$temporary_dir" "command-code@$version" >/dev/null
tar -xzf "$temporary_dir/command-code-$version.tgz" -C "$temporary_dir"
jq 'del(.devDependencies)' "$temporary_dir/package/package.json" > "$temporary_dir/package.json"
cp "$temporary_dir/package.json" "$package_dir/package.json"

cd "$package_dir"
npm install \
  --package-lock-only \
  --ignore-scripts \
  --omit=dev \
  --no-audit \
  --no-fund

cd "$(git -C "$package_dir" rev-parse --show-toplevel)"
NIXPKGS_ALLOW_UNFREE=1 nix-update command-code --version "$version" --build
