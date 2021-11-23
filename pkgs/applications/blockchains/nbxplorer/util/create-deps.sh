#!/usr/bin/env nix-shell
#!nix-shell -i bash -p dotnet-sdk_3
# shellcheck shell=bash
set -euo pipefail

# Writes deps for dotnet package in $pkgSrc to $depsFile.
# Expects $pkgSrc to contain a single .sln file.

pkgSrc=$1
depsFile=$(realpath "$2")
customFlags=$3

sln=$(cd "$pkgSrc"; find * -maxdepth 0 -name '*.sln' | head -1)
[[ $sln ]] || { echo "No .sln file in $pkgSrc" ; exit 1; }

tmpdir=$(mktemp -d /tmp/$pkgName-src.XXX)
echo "Using tmp dir: $tmpdir"
cp -rT "$pkgSrc" "$tmpdir"
chmod -R +w "$tmpdir"

pushd "$tmpdir" > /dev/null
mkdir home
echo "Running dotnet restore for $sln"
HOME=home DOTNET_CLI_TELEMETRY_OPTOUT=1 \
  dotnet restore $customFlags -v normal --no-cache "$sln" > restore_log

echo "{ fetchNuGet }: [" > "$depsFile"
while read pkgSpec; do
  { read name; read version; } < <(
    # Ignore build version part: 1.0.0-beta2+77df2220 -> 1.0.0-beta2
    sed -nE 's/.*<id>([^<]*).*/\1/p; s/.*<version>([^<+]*).*/\1/p' "$pkgSpec"
  )
  sha256=$(nix-hash --type sha256 --flat --base32 "$(dirname "$pkgSpec")"/*.nupkg)
  cat >> "$depsFile" <<EOF
  (fetchNuGet {
    name = "$name";
    version = "$version";
    sha256 = "$sha256";
  })
EOF
done < <(find home/.nuget/packages -name '*.nuspec' | LC_ALL=C sort)
echo "]" >> "$depsFile"

echo "Created $depsFile"

popd > /dev/null
rm -r $tmpdir
