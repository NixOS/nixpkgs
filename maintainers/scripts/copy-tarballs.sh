#! /bin/sh -e

urls=$(nix-instantiate --eval-only --xml --strict '<nixpkgs/maintainers/scripts/eval-release.nix>' \
    | grep -A2 'name="urls"' \
    | grep '<string value=' \
    | sed 's/.*"\(.*\)".*/\1/' \
    | sort | uniq)

for url in $urls; do
    if echo "$url" | grep -q -E "www.cs.uu.nl|nixos.org|.stratego-language.org|java.sun.com|ut2004|linuxq3a|RealPlayer|Adbe|belastingdienst|microsoft|armijn/.nix|sun.com|archive.eclipse.org"; then continue; fi
    $(dirname $0)/copy-tarball.sh "$url"
done

echo DONE
