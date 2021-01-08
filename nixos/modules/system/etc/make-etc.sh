source $stdenv/setup

mkdir -p $out/etc

readarray -t items < <(jq -c '.[]' < "$data")

for item in "${items[@]}"; do
    source="$(jq -nr '$item.source' --argjson item "$item")"
    target="$(jq -nr '$item.target' --argjson item "$item")"
    mode="$(jq -nr '$item.mode' --argjson item "$item")"
    user="$(jq -nr '$item.user' --argjson item "$item")"
    group="$(jq -nr '$item.group' --argjson item "$item")"

    if [[ "$source" =~ '*' ]]; then

        # If the source name contains '*', perform globbing.
        mkdir -p "$out/etc/$target"
        for fn in $source; do
            ln -s "$fn" "$out/etc/$target/"
        done

    else

        mkdir -p $out/etc/$(dirname "$target")
        if ! [ -e $out/etc/"$target" ]; then
            ln -s "$source" "$out/etc/$target"
        else
            echo "duplicate entry $target -> $source"
            if test "$(readlink "$out/etc/$target")" != "$source"; then
                echo "mismatched duplicate entry $(readlink "$out/etc/$target") <-> $source"
                exit 1
            fi
        fi

        if test "$mode" != symlink; then
            echo "$mode"  > "$out/etc/$target.mode"
            echo "$user"  > "$out/etc/$target.uid"
            echo "$group" > "$out/etc/$target.gid"
        fi

    fi
done
