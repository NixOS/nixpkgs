#!/usr/bin/env nix-shell
#!nix-shell -I nixpkgs=../../../.. -i bash -p curl gnused jq common-updater-scripts nuget-to-nix
set -euox pipefail
cd "$(dirname "${BASH_SOURCE[0]}")"

deps_file="$(realpath ./deps)"

new_version="$(curl ${GITHUB_TOKEN:+" -u \":$GITHUB_TOKEN\""} -s "https://api.github.com/repos/JustArchiNET/ArchiSteamFarm/releases" | jq -r  'map(select(.prerelease == false)) | .[0].tag_name')"
old_version="$(sed -nE 's/\s*version = "(.*)".*/\1/p' ./default.nix)"

if [[ "$new_version" == "$old_version" ]]; then
  echo "Already up to date!"
  if [[ "$1" != "--deps-only" ]]; then
    exit 0
  fi
fi

asf_path=$(pwd)
cd ../../../..

nixpkgs_path=$(pwd)
if [[ "${1:-}" != "--deps-only" ]]; then
    update-source-version ArchiSteamFarm "$new_version"
fi
store_src="$(nix-build -A ArchiSteamFarm.src --no-out-link)"
platforms="$(nix-instantiate --strict --eval --json -A ArchiSteamFarm.meta.platforms | jq -r .[])"
src="$(mktemp -d /tmp/ArchiSteamFarm-src.XXX)"

trap '
  rm -r "$src"
' EXIT

cp -rT "$store_src" "$src"
chmod -R +w "$src"

pushd "$src"

export DOTNET_NOLOGO=1
export DOTNET_CLI_TELEMETRY_OPTOUT=1

for i in $platforms; do
  nix-shell -I nixpkgs="$nixpkgs_path" -p dotnet-sdk_6 --argstr system $i --run "
     mkdir ./nuget_pkgs-$i
     for project in ArchiSteamFarm/ArchiSteamFarm.csproj ArchiSteamFarm.Tests/ArchiSteamFarm.Tests.csproj; do
       dotnet restore \$project --packages ./nuget_pkgs-$i
     done;

     nuget-to-nix ./nuget_pkgs-$i > $deps_file-$i.nix" \
  || echo "Did you set up binformat for $i?";
done;

cd "$asf_path"
./web-ui/update.sh
