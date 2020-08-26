#! /usr/bin/env nix-shell
#! nix-shell -i bash -p dotnet-sdk_3 nixfmt

# Run this script to generate deps.nix
# ./create_deps.sh /path/to/package/source/checkout > deps.nix

# TODO: consolidate with other dotnet deps generation scripts by which
#       this script is inspired:
#       - pkgs/servers/nosql/eventstore/create-deps.sh
#       - pkgs/development/dotnet-modules/python-language-server/create_deps.sh

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


function generate_restore_log() {
  checkout_path=$1
  >&2 echo "generating restore log for $checkout_path..."
  cd $checkout_path
  dotnet nuget locals all --clear
  dotnet restore -v normal --no-cache WalletWasabi.Backend -r linux-x64
  cd -
}

function process_restore_log() {
  restore_log=$1
  >&2 echo "processing restore log..."
  while read line; do
    if echo $line | grep -q "^[[:space:]]*Installing"; then
      l=$(echo $line | xargs)
      l=${l#Installing }
      l=${l%.}
      echo $l
    fi
  done < $restore_log
}

function prefetch_deps() {
  processed_log=$1
  >&2 echo "prefetching deps..."
  while read line; do
    name=$(echo $line | cut -d' ' -f1)
    >&2 echo "prefetching '$name' version: $version"
    version=$(echo $line | cut -d' ' -f2)
    hash=$(nix-prefetch-url "$URLBASE/$name/$version" 2>/dev/null)
    echo "$name $version $hash"
  done < $processed_log
}

function generate_deps_expression() {
  packages=$1
  >&2 echo "generating deps nix-expression..."
  echo $DEPS_HEADER
  while read line; do
    name=$(echo $line | cut -d' ' -f1)
    version=$(echo $line | cut -d' ' -f2)
    hash=$(echo $line | cut -d' ' -f3)
    printf "$DEPS_TEMPLATE" $name $version $hash
  done < $packages
  echo $DEPS_FOOTER
}

function main() {
  checkout_path=$1
  tmpdir=$(mktemp -d)
  generate_restore_log $checkout_path > $tmpdir/restore.log
  process_restore_log $tmpdir/restore.log > $tmpdir/processed.log
  prefetch_deps $tmpdir/processed.log > $tmpdir/prefetched.log
  generate_deps_expression $tmpdir/prefetched.log > $tmpdir/deps.nix
  nixfmt $tmpdir/deps.nix
  cat $tmpdir/deps.nix
  rm -rf $tmpdir
}

if [ ! -d "$1" ]; then
    >&2 echo "First argument must be a directory, the path to the package source checkout"
    exit 1
fi

main $@
