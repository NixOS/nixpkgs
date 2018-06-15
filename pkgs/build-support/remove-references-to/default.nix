# The program `remove-references-to' created by this derivation replaces all
# references to the given Nix store paths in the specified files by a
# non-existent path (/nix/store/eeee...).  This is useful for getting rid of
# dependencies that you know are not actually needed at runtime.

{ stdenv, writeScriptBin }:

writeScriptBin "remove-references-to" ''
#! ${stdenv.shell} -e

# References to remove
targets=()
while getopts t: o; do
    case "$o" in
        t) storeId=$(echo "$OPTARG" | sed -n "s|^$NIX_STORE/\\([a-z0-9]\{32\}\\)-.*|\1|p")
           if [ -z "$storeId" ]; then
               echo "-t argument must be a Nix store path"
               exit 1
           fi
           targets+=("$storeId")
    esac
done
shift $(($OPTIND-1))

# Files to remove the references from
regions=()
for i in "$@"; do
    test ! -L "$i" -a -f "$i" && regions+=("$i")
done

for target in "''${targets[@]}" ; do
    sed -i -e "s|$NIX_STORE/$target-|$NIX_STORE/eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee-|g" "''${regions[@]}"
done
''
