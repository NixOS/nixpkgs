# shellcheck shell=bash

# Starsector
version=$(curl -s https://fractalsoftworks.com/preorder/ | grep -oP "https://f005.backblazeb2.com/file/fractalsoftworks/release/starsector_linux-\K.*?(?=\.zip)" | head -1)
update-source-version "$pname" "$version" --file=./pkgs/by-name/st/starsector/package.nix
