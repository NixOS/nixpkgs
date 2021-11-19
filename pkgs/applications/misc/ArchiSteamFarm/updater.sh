#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl gnused jq common-updater-scripts nuget-to-nix dotnet-sdk_5
# shellcheck shell=bash
set -eo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")"

deps_file="$(realpath ./deps.nix)"

new_version="$(curl ${GITHUB_TOKEN:+" -u \":$GITHUB_TOKEN\""} -s "https://api.github.com/repos/JustArchiNET/ArchiSteamFarm/releases" | jq -r  'map(select(.prerelease == false)) | .[0].tag_name')"
old_version="$(sed -nE 's/\s*version = "(.*)".*/\1/p' ./default.nix)"

if [[ "$new_version" == "$old_version" ]]; then
  echo "Already up to date!"
  exit 0
fi

cd ../../../..
update-source-version ArchiSteamFarm "$new_version"
store_src="$(nix-build -A ArchiSteamFarm.src --no-out-link)"
src="$(mktemp -d /tmp/ArchiSteamFarm-src.XXX)"
cp -rT "$store_src" "$src"
chmod -R +w "$src"

pushd "$src"

export DOTNET_NOLOGO=1
export DOTNET_CLI_TELEMETRY_OPTOUT=1

mkdir ./nuget_pkgs
dotnet restore ArchiSteamFarm.sln --packages ./nuget_pkgs

nuget-to-nix ./nuget_pkgs > "$deps_file"

trap ''
  popd
  rm -r "$src"
'' EXIT
