#! /bin/sh -e

distDir=/data/webserver/tarballs

urls=$(nix-instantiate --eval-only --xml --strict ./eval-release.nix \
    | grep -A2 'name="urls"' \
    | grep '<string value=' \
    | sed 's/.*"\(.*\)".*/\1/' \
    | sort | uniq)

for url in $urls; do
    
    if echo "$url" | grep -q -E "www.cs.uu.nl|nixos.org|.stratego-language.org|java.sun.com|ut2004|linuxq3a|RealPlayer|Adbe|belastingdienst|microsoft|armijn/.nix|sun.com|archive.eclipse.org"; then continue; fi

    base="$(basename "$url")"
    newPath="$distDir/$base"

    if ! test -e "$newPath"; then

        #if echo $url | grep -q 'mirror://'; then
        #   echo "$fn: skipping mirrored $url"
        #   continue
        #fi

        echo "downloading $url to $newPath"

        if test -n "$doCopy"; then
            declare -a res
            if ! res=($(PRINT_PATH=1 nix-prefetch-url "$url")); then
                continue
            fi
            storePath=${res[1]}
            cp $storePath "$newPath.tmp.$$"
            mv -f "$newPath.tmp.$$" "$newPath"
        fi
        
    fi

    if test -n "$doCopy" -a -e "$newPath"; then

        echo "hashing $newPath"

        md5=$(nix-hash --flat --type md5 "$newPath")
        ln -sfn "../$base" $distDir/md5/$md5

        sha1=$(nix-hash --flat --type sha1 "$newPath")
        ln -sfn "../$base" $distDir/sha1/$sha1

        sha256=$(nix-hash --flat --type sha256 "$newPath")
        ln -sfn "../$base" $distDir/sha256/$sha256
        ln -sfn "../$base" $distDir/sha256/$(nix-hash --type sha256 --to-base32 "$sha256")

    fi

done

echo DONE
