#!/usr/bin/env bash

IFS="
"

for dll in $(find -iname \*.dll)
do
    baseName="$(basename "$dll" | sed "s/.dll$//i")"
    if pkg-config "$baseName"
    then
        candidateDll="$(pkg-config "$baseName" --variable=Libraries)"

        if diff "$dll" "$candidateDll" >/dev/null
        then
            echo "$dll is identical to $candidateDll. Substituting..."
            rm -vf "$dll"
            ln -sv "$candidateDll" "$dll"
        else
            echo "$dll and $candidateDll share the same name but have different contents, leaving alone."
        fi
    fi
done
