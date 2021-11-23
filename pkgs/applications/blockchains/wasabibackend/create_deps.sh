#! /usr/bin/env nix-shell
#! nix-shell -i bash -p dotnet-sdk_3 jq xmlstarlet curl nixpkgs-fmt
# shellcheck shell=bash
set -euo pipefail

# Run this script to generate deps.nix

# TODO: consolidate with other dotnet deps generation scripts by which
#       this script is inspired:
#       - pkgs/servers/nosql/eventstore/create-deps.sh
#       - pkgs/development/dotnet-modules/python-language-server/create_deps.sh
#       - pkgs/misc/emulators/ryujinx/updater.sh

cd "$(dirname "${BASH_SOURCE[0]}")"

deps_file="$(realpath "./deps.nix")"

exec 2>&1 6> "$deps_file"

store_src="$( nix-build ../../../.. -A wasabibackend.src --no-out-link )"
src="$(mktemp -d)"
cp -rT "$store_src" "$src"
chmod -R +w "$src"
pushd "$src"

URLBASE="https://www.nuget.org/api/v2/package"

DEPS_HEADER="
{ fetchurl }:
let
  nugetUrlBase = \"$URLBASE\";
  fetchNuGet = { name, version, sha256 }: fetchurl {
    inherit sha256;
    url = \"\${nugetUrlBase}/\${name}/\${version}\";
  };
in ["

DEPS_FOOTER="]"

DEPS_TEMPLATE="
(fetchNuGet {
  name = \"%s\";
  version = \"%s\";
  sha256 = \"%s\";
})"

tmpdir="$(mktemp -d -p "$(pwd)")" # must be under source root
trap 'rm -rf "$tmpdir"' EXIT

HOME="$tmpdir" dotnet restore --packages "$tmpdir"/.nuget/packages \
        --no-cache --force --runtime linux-x64 \
        WalletWasabi.Backend/WalletWasabi.Backend.csproj >&2

mapfile -t repos < <(
    xmlstarlet sel -t -v 'configuration/packageSources/add/@value' -n NuGet.config "$tmpdir"/.nuget/NuGet/NuGet.Config |
        while IFS= read index
        do
            curl --compressed -fsL "$index" | \
                jq -r '.resources[] | select(."@type" == "PackageBaseAddress/3.0.0")."@id"'
        done
)

echo $DEPS_HEADER >&6

cd "$tmpdir/.nuget/packages"
for package in *
do
    cd "$package"
    for version in *
    do
        found=false
        for repo in "${repos[@]}"
        do
            url="$repo$package/$version/$package.$version.nupkg"
            if curl -fsL "$url" -o /dev/null
            then
                found=true
                break
            fi
        done

        if ! $found
        then
            echo "couldn't find $package $version" >&2
            exit 1
        fi

        sha256=$(nix-prefetch-url "$url" 2>/dev/null)

        printf "$DEPS_TEMPLATE" $package $version $sha256 >&6
    done
    cd ..
done

echo $DEPS_FOOTER >&6

exec 6>&-

nixpkgs-fmt "$deps_file"
