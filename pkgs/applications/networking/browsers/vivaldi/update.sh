#!/usr/bin/env nix-shell
#!nix-shell -i bash -p libarchive curl common-updater-scripts

set -eu -o pipefail

cd "$(dirname "${BASH_SOURCE[0]}")"
root=../../../../..
export NIXPKGS_ALLOW_UNFREE=1

version() {
	(cd "$root" && nix-instantiate --eval --strict -A "$1.version" | tr -d '"')
}

vivaldi_version_old=$(version vivaldi)
vivaldi_version=$(curl -sS https://vivaldi.com/download/ | sed -rne 's/.*vivaldi-stable_([0-9]+\.[0-9]+\.[0-9]+\.[0-9]+-[0-9]+)_amd64\.deb.*/\1/p')

if [[ "$vivaldi_version" = "$vivaldi_version_old" ]]; then
	echo "nothing to do, vivaldi $vivaldi_version is current"
	exit
fi

# Download vivaldi and save hash and file path.
url="https://downloads.vivaldi.com/stable/vivaldi-stable_${vivaldi_version}_amd64.deb"
mapfile -t prefetch < <(nix-prefetch-url --print-path "$url")
hash=${prefetch[0]}
path=${prefetch[1]}

echo "vivaldi: $vivaldi_version_old -> $vivaldi_version"
(cd "$root" && update-source-version vivaldi "$vivaldi_version" "$hash")

# Check vivaldi-ffmpeg-codecs version.
chromium_version_old=$(version vivaldi-ffmpeg-codecs)
chromium_version=$(bsdtar xOf "$path" data.tar.xz | bsdtar xOf - ./opt/vivaldi/vivaldi-bin | strings | grep -A2 -i '^chrome\/' | grep '^[0-9]\+\.[0-9]\+\.[1-9][0-9]\+\.[0-9]\+')

if [[ "$chromium_version" != "$chromium_version_old" ]]; then
	echo "vivaldi-ffmpeg-codecs: $chromium_version_old -> $chromium_version"
	(cd "$root" && update-source-version vivaldi-ffmpeg-codecs "$chromium_version")
fi
