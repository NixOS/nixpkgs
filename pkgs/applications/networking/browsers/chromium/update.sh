#!/bin/sh

bucket_url="http://commondatastorage.googleapis.com/chromium-browser-official/";

get_newest_version()
{
    curl -s "$bucket_url" | sed -ne ' H;/<[Kk][Ee][Yy]>chromium-[^<]*</h;${
    g;s/^.*<Key>chromium-\([^<.]\+\(\.[^<.]\+\)\+\)\.tar\.bz2<.*$/\1/p
    }';
}

cd "$(dirname "$0")";

version="$(get_newest_version)";

if [ -e source.nix ]; then
    oldver="$(sed -n 's/^ *version *= *"\([^"]\+\)".*$/\1/p' source.nix)";
    if [ "x$oldver" = "x$version" ]; then
        echo "Already the newest version: $version" >&2;
        exit 1;
    fi;
fi;

url="${bucket_url%/}/chromium-$version.tar.bz2";

sha256="$(nix-prefetch-url "$url")";

cat > source.nix <<EOF
{
  version = "$version";
  url = "$url";
  sha256 = "$sha256";
}
EOF
