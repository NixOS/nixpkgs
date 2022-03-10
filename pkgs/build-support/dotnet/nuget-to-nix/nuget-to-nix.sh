#!/usr/bin/env bash

set -euo pipefail

if [ $# -eq 0 ]; then
  >&2 echo "Usage: $0 [packages directory] > deps.nix"
  exit 1
fi

pkgs=$1
tmpfile=$(mktemp /tmp/nuget-to-nix.XXXXXX)
trap 'rm -f "$tmpfile" EXIT

echo "{ fetchNuGet }: ["

while read pkg_spec; do
  { read pkg_name; read pkg_version; } < <(
    # Build version part should be ignored: `3.0.0-beta2.20059.3+77df2220` -> `3.0.0-beta2.20059.3`
    sed -nE 's/.*<id>([^<]*).*/\1/p; s/.*<version>([^<+]*).*/\1/p' "$pkg_spec")
  pkg_sha256="$(nix-hash --type sha256 --flat --base32 "$(dirname "$pkg_spec")"/*.nupkg)"

  echo "  (fetchNuGet { pname = \"$pkg_name\"; version = \"$pkg_version\"; sha256 = \"$pkg_sha256\"; })" >> ${tmpfile}
done < <(find $1 -name '*.nuspec')

LC_ALL=C sort --ignore-case ${tmpfile}

echo "]"
