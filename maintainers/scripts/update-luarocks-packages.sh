#!/usr/bin/env nix-shell
#!nix-shell -i bash -p lua5_2.withPackages(ps:[ps.luarocks-nix]) nix-prefetch-scripts

# You'll likely want to use
# ``
# nixpkgs $ maintainers/scripts/update-luarocks-packages.sh > pkgs/top-level/lua-generated-packages.nix
# ``
# to update all libraries in that folder.


# stop the script upon C-C
set -eu -o pipefail

if [ $# -lt 1 ]; then
    echo "Usage: $0 GENERATED_FILENAME"
    echo "(most likely pkgs/top-level/lua-generated-packages.nix)"
    exit 1
fi

GENERATED_NIXFILE="$1"
PACKAGE=""
# we have to use a temp file else
TMP_FILE="$(mktemp)"

exit_trap()
{
  local lc="$BASH_COMMAND" rc=$?
  test $rc -eq 0 || echo "*** error $rc: $lc"
}

trap exit_trap EXIT


# -p <PKG> package
while getopts "p:" opt; do
  case $opt in
    p)
      echo "Generating nix derivation for $OPTARG !" >&2
      PACKAGE="$OPTARG"
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      ;;
  esac
done

# read returns a non-zero return code when it reaches EOF
# so disable the checks just for the 2 read
set +e
read -d '' -r HEADER <<EOM
/* ${GENERATED_NIXFILE} is an auto-generated file -- DO NOT EDIT!
Regenerate it with:
nixpkgs$ ${0} ${GENERATED_NIXFILE}
*/
{
self
, lua
, buildLuaPackage
, stdenv
, fetchurl
, luaAtLeast
, luaOlder
, isLua51
, isLua52
, ...
} @ args:
with self;
rec {
EOM

read -d '' -r FOOTER <<'EOM'
}
/* GENERATED */
EOM

set -e


function convert_pkg () {
    pkg="$1"
	server=""
	if [ ! -z "$2" ]; then
		server=" --server=$2"
	fi

    echo "looking at $pkg from server $server" >&2
    drv=$(luarocks convert2nix $server "$pkg")
    if [ $? -gt 0 ]; then
        echo "Failed to convert $pkg" >&2
        echo "$drv" >&2
    else
        echo "$drv" | tee -a "$TMP_FILE"
    fi
}

# list of packages
source maintainers/scripts/lua_packages.sh

# params needed when called via callPackage
echo "$HEADER" | tee $TMP_FILE

if [ ! -z $PACKAGE ]; then
    convert_pkg "$PACKAGE" "${pkg_list[$PACKAGE]}"
else
    for pkg_name in "${!pkg_list[@]}";
    do
        convert_pkg $pkg_name "${pkg_list[$pkg_name]}"
    done
fi
# close the set
echo "$FOOTER" | tee -a "$TMP_FILE"

cp "$TMP_FILE" "$GENERATED_NIXFILE"
