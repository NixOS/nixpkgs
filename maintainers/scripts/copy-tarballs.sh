#! /bin/sh -e

urls=$(nix-instantiate --eval-only --xml --strict '<nixpkgs/maintainers/scripts/eval-release.nix>' \
    | grep -A2 'name="urls"' \
    | grep '<string value=' \
    | sed 's/.*"\(.*\)".*/\1/' \
    | sort | uniq)

for url in $urls; do
    if echo "$url" | grep -q -E "www.cs.uu.nl|nixos.org|.stratego-language.org|java.sun.com|ut2004|linuxq3a|RealPlayer|Adbe|belastingdienst|microsoft|armijn/.nix|sun.com|archive.eclipse.org"; then continue; fi

    # Check the URL scheme.
    if ! echo "$url" | grep -q -E "^[a-z]+://"; then echo "skipping $url (no URL scheme)"; continue; fi

    # Check the basename.  It should include something resembling a version.
    base="$(basename "$url")"
    #if ! echo "$base" | grep -q -E "[-_].*[0-9].*"; then echo "skipping $url (no version)"; continue; fi
    if ! echo "$base" | grep -q -E "[a-zA-Z]"; then echo "skipping $url (no letter in name)"; continue; fi
    if ! echo "$base" | grep -q -E "[0-9]"; then echo "skipping $url (no digit in name)"; continue; fi
    if ! echo "$base" | grep -q -E "[-_\.]"; then echo "skipping $url (no dot/underscore in name)"; continue; fi
    if echo "$base" | grep -q -E "[&?=%]"; then echo "skipping $url (bad character in name)"; continue; fi
    if [ "${base:0:1}" = "." ]; then echo "skipping $url (starts with a dot)"; continue; fi

    $(dirname $0)/copy-tarball.sh "$url"
done

echo DONE
