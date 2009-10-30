source $stdenv/setup

ensureDir $out/etc

sources_=($sources)
targets_=($targets)
modes_=($modes)
for ((i = 0; i < ${#targets_[@]}; i++)); do
    ensureDir $out/etc/$(dirname ${targets_[$i]})
    if ! test -e $out/etc/${targets_[$i]}; then
        ln -s ${sources_[$i]} $out/etc/${targets_[$i]};
    else
        echo "Duplicate entry ${targets_[$i]} -> ${sources_[$i]}"
        if test "$(readlink $out/etc/${targets_[$i]})" != "${sources_[$i]}"; then
            echo "Mismatched duplicate entry $(readlink $out/etc/${targets_[$i]}) <-> ${sources_[$i]}"
	    exit 1
        fi
    fi;
    if test "${modes_[$i]}" != symlink; then
        echo "${modes_[$i]}" > $out/etc/${targets_[$i]}.mode
    fi
done
