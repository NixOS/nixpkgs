#! /bin/sh -e

find . -name "*.nix" | while read fn; do

    grep -E '^ *url = ' "$fn" | while read line; do

        if oldURL=$(echo "$line" | sed 's^url = \(.*\);^\1^'); then

            if ! echo "$oldURL" | grep -q -E "www.cs.uu.nl|nix.cs.uu.nl|.stratego-language.org|java.sun.com|ut2004|linuxq3a|RealPlayer|Adbe"; then
                base=$(basename $oldURL)
                newURL="http://nix.cs.uu.nl/dist/tarballs/$base"
                newPath="/data/webserver/dist/tarballs/$base"
                echo "$fn: $oldURL -> $newURL"

#		if test -e "$newPath"; then
#		    echo "WARNING: $newPath exists!"
#		else

		    if ! test -e "$newPath"; then
			curl --fail --location --max-redirs 20 "$oldURL" > "$newPath".tmp
			mv -f "$newPath".tmp "$newPath"

		    fi

		    sed "s^$oldURL^$newURL^" < "$fn" > "$fn".tmp
		    mv -f "$fn".tmp "$fn"

#		fi

            fi
            
        fi
    
    done

done