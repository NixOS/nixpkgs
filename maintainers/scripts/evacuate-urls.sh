#! /bin/sh -e

find . -name "*.nix" | while read fn; do

    grep -E '^ *url = ' "$fn" | while read line; do

        if oldURL=$(echo "$line" | sed 's^url = \(.*\);^\1^'); then

            if ! echo "$oldURL" | grep -q -E ".cs.uu.nl|.stratego-language.org|java.sun.com|ut2004|linuxq3a"; then
                base=$(basename $oldURL)
                newURL="http://catamaran.labs.cs.uu.nl/dist/tarballs/$base"
                newPath="/mnt/scratchy/eelco/public_html/tarballs/$base"
                echo "$fn: $oldURL -> $newURL"

                if ! test -e "$newPath"; then
                    curl --fail --location --max-redirs 20 "$oldURL" > "$newPath".tmp
                    mv -f "$newPath".tmp "$newPath"
                fi

                sed "s^$oldURL^$newURL^" < "$fn" > "$fn".tmp
                mv -f "$fn".tmp "$fn"
            fi
            
        fi
    
    done

done