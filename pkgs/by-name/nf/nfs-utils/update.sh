#!/usr/bin/env nix-shell
#!nix-shell -i bash -p coreutils gnugrep common-updater-scripts nix-update

# tags look like nfs-utils-2-8-4
version=$(list-git-tags --url=git://git.linux-nfs.org/projects/steved/nfs-utils.git | grep -oP '^nfs-utils-\d+-\d+-\d+$' | sort -rV | head -1)
# remove nfs-utils- prefix
version="${version#nfs-utils-}"
# replace - with .
version="${version//-/.}"
nix-update --version="$version" nfs-utils
