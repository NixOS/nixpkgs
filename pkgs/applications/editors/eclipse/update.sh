#!/usr/bin/env nix-shell
#! nix-shell -i bash --pure -p curl cacert nix jq
#! nix-shell -I nixpkgs=https://github.com/NixOS/nixpkgs/archive/5b2c2d84341b2afb5647081c1386a80d7a8d8605.tar.gz
#                                                                ^
#                                                                |
#                   nixos-unstable ~ 2026-03-16 -----------------/

set -o errexit
set -o nounset

# scrape the downloads page for release info

curl -s -O https://download.eclipse.org/eclipse/downloads/data.json
trap "rm data.json" EXIT

dlquery() {
    q="$1"
    cat data.json | jq -r ".releases[0] | $q";
}

# extract release info from download page HTML

platform_major=$(dlquery '.label | split(".") | .[0]');
platform_minor=$(dlquery '.label | split(".") | .[1]');

year=$(dlquery '.path | split("/") | .[] | select(. | startswith("R")) | split("-") | .[2] | .[0:4]')
buildmonth=$(dlquery '.path | split("/") | .[] | select(. | startswith("R")) | split("-") | .[2] | .[4:6]')
builddaytime=$(dlquery '.path | split("/") | .[] | select(. | startswith("R")) | split("-") | .[2] | .[6:12]')
timestamp="${year}${buildmonth}${builddaytime}";

# account for possible release-month vs. build-month mismatches

month=$buildmonth;
case "$buildmonth" in
    '02'|'04') month='03' ;;
    '05'|'07') month='06' ;;
    '08'|'10') month='09' ;;
    '11'|'01') month='12' ;;
esac

ECLIPSES_JSON=$(dirname $0)/eclipses.json;

t=$(mktemp);
# note: including platform_major, platform_minor, and version may seem redundant
# the first two are needed for the derivation itself; the third is necessary so
# that nixpkgs-update can see that the version changes as a result of this update
# script.
cat $ECLIPSES_JSON | jq ". + {platform_major: \"${platform_major}\",platform_minor: \"${platform_minor}\",version:\"${platform_major}.${platform_minor}\",year: \"${year}\",month: \"${month}\",buildmonth: \"${buildmonth}\",dayHourMinute: \"${builddaytime}\"}" > $t;
mv $t $ECLIPSES_JSON;

# prefetch new download hashes

for id in $(cat $ECLIPSES_JSON | jq -r '.eclipses | keys | .[]'); do
    for arch in x86_64 aarch64; do
        if [ $(cat $ECLIPSES_JSON | jq -r ".eclipses.${id}.dropUrl") == "true" ]; then
            url="https://www.eclipse.org/downloads/download.php?r=1&nf=1&file=/eclipse/downloads/drops${platform_major}/R-${platform_major}.${platform_minor}-${timestamp}/eclipse-${id}-${platform_major}.${platform_minor}-linux-gtk-${arch}.tar.gz";
        else
            url="https://www.eclipse.org/downloads/download.php?r=1&nf=1&file=/technology/epp/downloads/release/${year}-${month}/R/eclipse-${id}-${year}-${month}-R-linux-gtk-${arch}.tar.gz";
        fi

        # sometimes a mirror is down; retrying a few times should eventually get us redirected to a working mirror
        for try in $(seq 1 5); do
            echo "prefetching ${id} ${arch} (try ${try})";
            h=$(nix store prefetch-file --json "$url" | jq -r .hash);

            if [ "$h" != "" ]; then break; fi
        done

        if [ "$h" == "" ]; then
            echo "unable to prefetch and hash ${id} for ${arch} from ${url}";
            echo "see above output for errors";
            exit 1;
        fi

        t=$(mktemp);
        cat $ECLIPSES_JSON | jq -r ".eclipses.${id}.hashes.${arch} = \"${h}\"" > $t;
        mv $t $ECLIPSES_JSON;
    done
done
