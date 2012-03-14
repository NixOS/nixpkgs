#!/bin/sh

usage() {
	echo "$0 version|directory"
}

download() {
	URL=ftp://ftp.kde.org/pub/kde/unstable/kde-telepathy/$1/src
	destdir=$2
	if test -n "$KDE_FULL_SESSION"; then
		kioclient copy $URL $destdir
	else
		mkdir $destdir
		lftp -c "open $URL; lcd $destdir; mget -c *"
	fi
}

if [[ -d $1 ]]; then
	directory=$1
	version=$(ls $directory/* | head -n1 |
		sed -e "s,$directory/[^0-9.]*\\([0-9.]\\+\\)\\.tar.*,\\1,")
	echo "Version $version"
else
	version=$1
	directory=src-$version
	download $version $directory
fi

packages=$(ls $directory/* | sed -e "s,$directory/ktp-\\(.*\\)-$version.*,\\1,")
echo $packages
exec >$version.nix
echo "["
for pkg in $packages; do
	hash=$(nix-hash --flat --type sha256 --base32 $directory/ktp-$pkg-$version.*)
	echo "{name=\"ktp-${pkg}\";key=\"${pkg//-/_}\";sha256=\"${hash}\";}"
done
echo "]"

