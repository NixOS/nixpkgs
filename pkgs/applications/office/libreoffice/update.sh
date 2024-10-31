#!/usr/bin/env nix-shell
#!nix-shell -i bash -p python3 pup curl jq nix nix-prefetch-git

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
elif [[ $variant == collabora ]]; then
    true
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

case $variant in
(fresh|still)
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
        echo "{ fetchurl, ... }:" > $t.nix
        echo "fetchurl {" >> $t.nix
        echo "  sha256 = "\"$(nix-prefetch-url $baseurl/libreoffice-$t-$full_version.tar.xz)'";' >> $t.nix
        echo "  url = "\"$baseurl/libreoffice-$t-$full_version.tar.xz'";' >> $t.nix
        echo "}" >> $t.nix
    done

    # Out of loop nix-prefetch-url, because there is no $t, and we want the output
    # path as well, to get the download.lst file from there afterwards.
    main_path_hash=($(nix-prefetch-url --print-path $baseurl/libreoffice-$full_version.tar.xz))
    echo "{ fetchurl, ... }:" > main.nix
    echo "fetchurl {" >> main.nix
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
    ;;

(collabora)
    all_tags=$(git ls-remote --tags --sort -v:refname https://gerrit.libreoffice.org/core)
    rev=$(grep --perl-regexp --only-matching --max-count=1 \
        '\Krefs/tags/cp-\d+\.\d+\.\d+-\d+$' <<< "$all_tags")
    full_version=${rev#refs/tags/cp-}
    echoerr full version is $full_version
    echo \"$full_version\" > version.nix

    # The full checkout including the submodules is too big for Hydra, so we fetch
    # submodules separately.
    declare -A dirnames=([help]=helpcontent2 [translations]=translations)
    for t in help translations; do
        sub_rev=$(curl --silent "https://git.libreoffice.org/core/+/$rev/${dirnames[$t]}" |\
            pup '.gitlink-detail text{}' |\
            sed -n 's/^Submodule link to \([0-9a-f]\{40\}\) of .*/\1/p')
        echoerr got rev $sub_rev for $t
        prefetch_output=$(nix-prefetch-git "https://gerrit.libreoffice.org/$t" --rev "$sub_rev")
        echo "{ fetchgit, ... }:" > $t.nix
        echo "fetchgit {" >> $t.nix
        echo "  url = \"$(jq -r '.url' <<< "$prefetch_output")\";" >> $t.nix
        echo "  rev = \"$rev\";" >> $t.nix
        echo "  hash = \"$(jq -r '.hash' <<< "$prefetch_output")\";" >> $t.nix
        echo "}"
    done

    local prefetch_output=$(nix-prefetch-git "https://gerrit.libreoffice.org/core" --rev "$rev")
    echo "{ fetchgit, ... }:" > main.nix
    echo "fetchgit {" >> main.nix
    echo "  url = \"$(jq -r '.url' <<< "$prefetch_output")\";" >> main.nix
    echo "  rev = \"$rev\";" >> main.nix
    echo "  hash = \"$(jq -r '.hash' <<< "$prefetch_output")\";" >> main.nix
    echo "  fetchSubmodules = false;" >> main.nix
    echo "}" >> main.nix

    # Environment variable required by ../generate-libreoffice-srcs.py
    export downloadList=$(jq -r '.path' <<< "$prefetch_output")/download.lst
esac

cd ..
python3 ./generate-libreoffice-srcs.py > src-$variant/deps.nix
