#! /bin/sh -e

distDir=/data/webserver/tarballs

url="$1"
file="$2"
if [ -z "$url" ]; then echo "syntax: $0 URL"; exit 0; fi

base="$(basename "$url")"
if [ -z "$base" ]; then echo "bad URL"; exit 1; fi
dstPath="$distDir/$base"

if [ -e "$dstPath" ]; then if [ -n "$VERBOSE" ]; then echo "$dstPath already exists"; fi; exit 0; fi

if [ -z "$file" ]; then

    echo "downloading $url to $dstPath"

    if [ -n "$DRY_RUN" ]; then exit 0; fi

    declare -a res
    if ! res=($(PRINT_PATH=1 nix-prefetch-url "$url")); then
        exit
    fi

    storePath=${res[1]}

else
    storePath="$file"
fi

cp $storePath "$dstPath.tmp.$$"
mv -f "$dstPath.tmp.$$" "$dstPath"

echo "hashing $dstPath"

md5=$(nix-hash --flat --type md5 "$dstPath")
ln -sfn "../$base" $distDir/md5/$md5

sha1=$(nix-hash --flat --type sha1 "$dstPath")
ln -sfn "../$base" $distDir/sha1/$sha1

sha256=$(nix-hash --flat --type sha256 "$dstPath")
ln -sfn "../$base" $distDir/sha256/$sha256
ln -sfn "../$base" $distDir/sha256/$(nix-hash --type sha256 --to-base32 "$sha256")
