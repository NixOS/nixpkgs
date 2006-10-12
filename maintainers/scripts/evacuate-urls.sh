#! /bin/sh -e

find . -name "*.nix" | while read fn; do

    grep -E '^ *url = ' "$fn" | while read line; do

        if oldURL=$(echo "$line" | sed 's^url = \(.*\);^\1^'); then

            if ! echo "$oldURL" | grep -q -E "www.cs.uu.nl|nix.cs.uu.nl|.stratego-language.org|java.sun.com|ut2004|linuxq3a|RealPlayer|Adbe|belastingdienst|microsoft|armijn/.nix|sun.com|archive.eclipse.org"; then
                base=$(basename $oldURL)
                newURL="http://nix.cs.uu.nl/dist/tarballs/$base"
                newPath="/data/webserver/dist/tarballs/$base"
                echo "$fn: $oldURL -> $newURL"

		isSafe=1

		if test -e "$newPath"; then
		    hash=$(fgrep -A 1 "$oldURL" "$fn" | grep md5 | sed 's^.*md5 = \"\(.*\)\";.*^\1^')
		    echo "HASH = $hash"
		    if ! test "$(nix-hash --type md5 --flat "$newPath")" = "$hash"; then
			echo "WARNING: $newPath exists and differs!"
			isSafe=
		    fi
		fi

		if test -n "$doMove" -a -n "$isSafe"; then

		    if ! test -e "$newPath"; then
			curl --disable-epsv --fail --location --max-redirs 20 "$oldURL" > "$newPath".tmp
			mv -f "$newPath".tmp "$newPath"
		    fi

		    sed "s^$oldURL^$newURL^" < "$fn" > "$fn".tmp
		    mv -f "$fn".tmp "$fn"

		fi

            fi
            
        fi
    
    done

done