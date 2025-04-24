#!/usr/bin/env nix-shell
#! nix-shell -i bash --pure -p curl cacert libxml2 yq nix jq
#! nix-shell -I nixpkgs=https://github.com/NixOS/nixpkgs/archive/3c7487575d9445185249a159046cc02ff364bff8.tar.gz
#                                                                ^
#                                                                |
#                   nixos-unstable ~ 2023-07-06 -----------------/

set -o errexit
set -o nounset

# scrape the downloads page for release info

curl -s -o eclipse-dl.html https://download.eclipse.org/eclipse/downloads/
trap "rm eclipse-dl.html" EXIT

dlquery() {
    q=$1
    xmllint --html eclipse-dl.html --xmlout 2>/dev/null | xq -r ".html.body.main.div.table[3].tr[1].td[0].a${q}";
}

# extract release info from download page HTML

platform_major=$(dlquery '."#text" | split(".") | .[0]' -r);
platform_minor=$(dlquery '."#text" | split(".") | .[1]' -r);

year=$(dlquery '."@href" | split("/") | .[] | select(. | startswith("R")) | split("-") | .[2] | .[0:4]')
buildmonth=$(dlquery '."@href" | split("/") | .[] | select(. | startswith("R")) | split("-") | .[2] | .[4:6]')
builddaytime=$(dlquery '."@href" | split("/") | .[] | select(. | startswith("R")) | split("-") | .[2] | .[6:12]')
timestamp="${year}${buildmonth}${builddaytime}";

# account for possible release-month vs. build-month mismatches

month=$buildmonth;
case "$buildmonth" in
    '02'|'04') month='03' ;;
    '05'|'07') month='06' ;;
    '08'|'10') month='09' ;;
    '11'|'01') month='12' ;;
esac

cat <<EOF

paste the following into the 'let' block near the top of pkgs/applications/editors/eclipse/default.nix:

  platform_major = "${platform_major}";
  platform_minor = "${platform_minor}";
  year = "${year}";
  month = "${month}"; #release month
  buildmonth = "${buildmonth}"; #sometimes differs from release month
  timestamp = "\${year}\${buildmonth}${builddaytime}";
EOF

# strip existing download hashes

sed -i 's/64 = ".*";$/64 = "";/g' pkgs/applications/editors/eclipse/default.nix

# prefetch new download hashes

echo;
echo "paste the following url + hash blocks into pkgs/applications/editors/eclipse/default.nix:";

for url in $(grep 'url = ' pkgs/applications/editors/eclipse/default.nix | grep arch | cut -d '"' -f 2); do
    u=$(echo "$url" | sed 's/&/\\&/g');
    echo;
    echo "        url = \"${url}\";";
    echo "        hash = {";
    for arch in x86_64 aarch64; do
        us=$(eval echo "$u");
        h=$(nix store prefetch-file --json "$us" | jq -r .hash);
        echo "          $arch = \"${h}\";";
    done
    echo '        }.${arch};';
done
