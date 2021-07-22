# Ensure the script fails properly
set -euo pipefail

# shellcheck disable=SC1091,SC2154
source "$stdenv/setup"

# shellcheck disable=SC2154
mkdir -p "$out/etc"

# This reads the JSON into a big array named 'entries'.
# Essentially, the jq converts every entry into a \0-separated
# string of the specified fields source, mode, ....
# Then all these strings are \0-separated as well and fed into
# readarray, resulting in a big list of blocks of the 5 fields.
# \0-separating the strings ensures **any** character can be part
# of any of the fields (since \0 is not a valid character in paths).
# shellcheck disable=SC2154
readarray -d $'\0' -t entries < <(jq -rj '[.[] | [.source, .target, .mode, .user, .group] | join("\u0000")] | join("\u0000")' < "${entriesPath}")

ret=0
for ((i = 0; i < ${#entries[@]}; i+=5)); do
    src="${entries[$i]}"
    target="${entries[$i + 1]}"
    mode="${entries[$i + 2]}"
    user="${entries[$i + 3]}"
    group="${entries[$i + 4]}"

    if [[ "$src" = *'*'* ]]; then

        # If the source name contains '*', perform globbing.
        mkdir -p "$out/etc/$target"
        for fn in $src; do
            ln -s "$fn" "$out/etc/$target/"
        done

    else

        mkdir -p "$out/etc/$(dirname "$target")"
        if ! [ -e "$out/etc/$target" ]; then
            ln -s "$src" "$out/etc/$target"
        else
            echo "duplicate entry $target -> $src"
            if [ "$(readlink "$out/etc/$target")" != "$src" ]; then
                echo "mismatched duplicate entry $(readlink "$out/etc/$target") <-> $src"
                ret=1
                continue
            fi
        fi

        if [ "${mode}" != symlink ]; then
            echo "${mode}" > "$out/etc/$target.mode"
            echo "${user}" > "$out/etc/$target.uid"
            echo "${group}" > "$out/etc/$target.gid"
        fi
    fi
done

exit "${ret}"
