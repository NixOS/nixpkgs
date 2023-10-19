#!/usr/bin/env nix-shell
#!nix-shell -i bash -p python3 pup curl jq nix

set -euo pipefail
echoerr() { echo "$@" 1>&2; }

fname="$1"
echoerr got fname $fname
shift

variant="$1"
# See comment near version_major variable
if [[ $variant == fresh ]]; then
    head_tail=head
elif [[ $variant == still ]]; then
    head_tail=tail
else
    echoerr got unknown variant $variant
    exit 3
fi
echoerr got variant $variant
shift

# Not totally needed, but makes it easy to run the update in case tis folder is
# deleted.
mkdir -p "$(dirname $fname)/src-$variant"
cd "$(dirname $fname)/src-$variant"

# The pup command prints both fresh and still versions one after another, and
# we use either head -1 or tail -1 to get the right version, per the if elif
# above.
version_major="$(curl --silent https://www.libreoffice.org/download/download-libreoffice/ |\
    pup '.dl_version_number text{}' | $head_tail -1)"
echoerr got from website ${variant}_version $version_major
baseurl=https://download.documentfoundation.org/libreoffice/src/$version_major
tarballs=($(curl --silent $baseurl/ |\
    pup 'table json{}' |\
    jq --raw-output '.. | .href? | strings' |\
    grep "$version_major.*.tar.xz$"))

full_version="$(echo ${tarballs[0]} | sed -e 's/^libreoffice-//' -e 's/.tar.xz$//')"
echoerr full version is $full_version
echo \"$full_version\" > version.nix

for t in help translations; do
    echo "{" > $t.nix
    echo "  sha256 = "\"$(nix-prefetch-url $baseurl/libreoffice-$t-$full_version.tar.xz)'";' >> $t.nix
    echo "  url = "\"$baseurl/libreoffice-$t-$full_version.tar.xz'";' >> $t.nix
    echo "}" >> $t.nix
done

# Out of loop nix-prefetch-url, because there is no $t, and we want the output
# path as well, to get the download.lst file from there afterwards.
main_path_hash=($(nix-prefetch-url --print-path $baseurl/libreoffice-$full_version.tar.xz))
echo "{" > main.nix
echo "  sha256 = "\"${main_path_hash[0]}'";' >> main.nix
echo "  url = "\"$baseurl/libreoffice-$full_version.tar.xz'";' >> main.nix
echo "}" >> main.nix
echoerr got filename ${main_path_hash[1]}

# Environment variable required by ../generate-libreoffice-srcs.py
export downloadList=/tmp/nixpkgs-libreoffice-update-download-$full_version.lst
# Need to extract the file only if it doesn't exist, otherwise spare time be
# skipping this.
if [[ ! -f "$downloadList" ]]; then
    tar --extract \
        --file=${main_path_hash[1]} \
        libreoffice-$full_version/download.lst \
        -O > $downloadList
else
    echoerr relying on previously downloaded downloadList file
fi
cd ..
python3 ./generate-libreoffice-srcs.py > src-$variant/deps.nix
