source $stdenv/setup

ensureDir $out/etc

sources_=($sources)
targets_=($targets)
modes_=($modes)
for ((i = 0; i < ${#targets_[@]}; i++)); do
    ensureDir $out/etc/$(dirname ${targets_[$i]})
    ln -s ${sources_[$i]} $out/etc/${targets_[$i]}
    if test "${modes_[$i]}" != symlink; then
        echo "${modes_[$i]}" > $out/etc/${targets_[$i]}.mode
    fi
done
