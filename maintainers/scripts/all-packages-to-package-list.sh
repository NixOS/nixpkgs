#!/usr/bin/env bash
# when run from the root of the repository this will convert trivial packages in
# all-packages.nix to package-list.nix format

set -e

looks_trivial=$(mktemp)
actually_trivial=$(mktemp)
maybe_nontrivial=$(mktemp)
new_paths=$(mktemp)
already_have=$(mktemp)
path_list=$(mktemp)

# find anything that looks like a trivial package expression
TRIVIAL='^  \([A-Za-z0-9_\-]\+\) = callPackage \(\.\./[^ ]\+/\1\) { *}; *$'
sed -n "s%${TRIVIAL}%\1 \2%p" pkgs/top-level/all-packages.nix > $looks_trivial

# filter out those that are potentially used more than once in all-packages.nix
while IFS= read -r -d $'\n' line ; do
    name=${line% *}
    path=${line#* }
    count=$(grep -F -- "$name" pkgs/top-level/all-packages.nix | wc -l)
    pcount=$(grep -F -- "$path" pkgs/top-level/all-packages.nix | wc -l)
    if [[ $count == 1 ]] && [[ $pcount == 1 ]]; then
        echo "$path" >> $actually_trivial
        echo "  ${path:1}"
    else
        echo "$line" >> $maybe_nontrivial
    fi
done < $looks_trivial > $new_paths

# generate new package-list.nix
cat pkgs/package-list.nix | tail -n +2 | head -n -1 > $already_have
cat $new_paths $already_have | sort | uniq > $path_list

{
    echo "["
    cat $path_list
    echo "]"
} > pkgs/package-list.nix

# generate new all-packages.nix
one=$(mktemp)
two=$(mktemp)
cat pkgs/top-level/all-packages.nix > $one
while IFS= read -r -d $'\n' line ; do
    awk '
BEGIN { ate = 0; }
{ if (index($0, "'"$line"'") != 0) { ate = 1; } else if ($0 != "" || ate != 1) { print $0; ate = 0; }; }
' < $one > $two
    mv $two $one
done < $actually_trivial

mv $one pkgs/top-level/all-packages.nix
mv $maybe_nontrivial maybe_nontrivial
rm $looks_trivial $actually_triviall $new_paths $already_have $path_list
