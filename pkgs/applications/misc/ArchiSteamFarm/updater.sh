#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl gnused jq common-updater-scripts nuget-to-nix
set -exo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")"

deps_file="$(realpath ./deps)"

new_version="$(curl ${GITHUB_TOKEN:+" -u \":$GITHUB_TOKEN\""} -s "https://api.github.com/repos/JustArchiNET/ArchiSteamFarm/releases" | jq -r  'map(select(.prerelease == false)) | .[0].tag_name')"
old_version="$(sed -nE 's/\s*version = "(.*)".*/\1/p' ./default.nix)"

if [[ "$new_version" == "$old_version" ]]; then
  echo "Already up to date!"
  exit 0
fi

cd ../../../..
update-source-version ArchiSteamFarm "$new_version"
store_src="$(nix-build -A ArchiSteamFarm.src --no-out-link)"
platforms="$(nix-instantiate --strict --eval --json -A ArchiSteamFarm.meta.platforms | jq -r .[])"
src="$(mktemp -d /tmp/ArchiSteamFarm-src.XXX)"
cp -rT "$store_src" "$src"
chmod -R +w "$src"

pushd "$src"

export DOTNET_NOLOGO=1
export DOTNET_CLI_TELEMETRY_OPTOUT=1

for i in $platforms; do
  nix-shell -p dotnet-sdk_6 --argstr system $i --run "
     mkdir ./nuget_pkgs-$i
     for project in ArchiSteamFarm/ArchiSteamFarm.csproj ArchiSteamFarm.Tests/ArchiSteamFarm.Tests.csproj; do
       dotnet restore $project --packages ./nuget_pkgs-$i
     done;

     nuget-to-nix ./nuget_pkgs-$i > $deps_file-$i.nix" \
  || echo "Did you set up binformat for $i?";

done;

trap '
  popd
  rm -r "$src"
' EXIT
