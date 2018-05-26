#! /usr/bin/env nix-shell
#! nix-shell -i bash -p curl go-pup

# Fetches a list of all available source mirrors from the sage homepage.
# Note that the list is sorted by country, but fetchurl doesn't offer an option
# to customize mirror preference.

curl -s http://www.sagemath.org/download-source.html \
    | pup 'table#mirror'  \
    | pup 'a attr{href}' \
    | sed -e 's/index\.html/sage-${version}.tar.gz/'
