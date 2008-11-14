#! /bin/sh -e

distDir=/data/webserver/dist/tarballs

find "$1" -name "*.nix" | while read fn; do

    grep -E '^ *url = ' "$fn" | while read line; do

        if url=$(echo "$line" | sed 's^url = \(.*\);^\1^'); then

            if ! echo "$url" | grep -q -E "www.cs.uu.nl|nixos.org|.stratego-language.org|java.sun.com|ut2004|linuxq3a|RealPlayer|Adbe|belastingdienst|microsoft|armijn/.nix|sun.com|archive.eclipse.org"; then
                base="$(basename "$url")"
                newPath="$distDir/$base"

		if test -e "$newPath"; then

		    #echo "$fn: checking hash of existing $newPath"
		    hash=$(fgrep -A 1 "$url" "$fn" | grep md5 | sed 's^.*md5 = \"\(.*\)\";.*^\1^')
		    hashType=md5
		    if test -z "$hash"; then
			hash=$(fgrep -A 1 "$url" "$fn" | grep sha256 | sed 's^.*sha256 = \"\(.*\)\";.*^\1^')
			hashType="sha256 --base32"
			if test -n "$hash"; then
			    if test "${#hash}" = 64; then
				hash=$(nix-hash --to-base32 --type sha256 $hash)
			    fi
			else
			    hash=$(fgrep -A 1 "$url" "$fn" | grep sha1 | sed 's^.*sha1 = \"\(.*\)\";.*^\1^')
			    hashType="sha1"
			    if test -z "$hash"; then
				echo "WARNING: $fn: cannot figure out the hash for $url"
				continue
			    fi
			fi
		    fi
		    #echo "HASH = $hash"
		    if ! test "$(nix-hash --type $hashType --flat "$newPath")" = "$hash"; then
			echo "WARNING: $fn: $newPath exists and differs, hash should be $hash!"
			continue
		    fi

		else

		    if echo $url | grep -q 'mirror://'; then
			#echo "$fn: skipping mirrored $url"
			continue
		    fi

		    echo "$fn: $url -> $newPath"

		    if test -n "$doCopy"; then
			if ! curl --disable-epsv --fail --location --max-redirs 20 --remote-time \
			    "$url" --output "$newPath".tmp; then
			    continue
			fi
		        mv -f "$newPath".tmp "$newPath"
		    fi

		fi

		if test -n "$doCopy" -a -e "$newPath"; then

		    md5=$(nix-hash --flat --type md5 "$newPath")
		    ln -sfn "../$base" $distDir/md5/$md5

		    sha1=$(nix-hash --flat --type sha1 "$newPath")
		    ln -sfn "../$base" $distDir/sha1/$sha1

		    sha256=$(nix-hash --flat --type sha256 "$newPath")
		    ln -sfn "../$base" $distDir/sha256/$sha256
		    ln -sfn "../$base" $distDir/sha256/$(nix-hash --type sha256 --to-base32 "$sha256")

		fi

            fi
            
        fi
    
    done

done

echo DONE
