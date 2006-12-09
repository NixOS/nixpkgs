source $stdenv/setup

ensureDir $out/etc

sources_=($sources)
targets_=($targets)
for ((i = 0; i < ${#targets_[@]}; i++)); do
    ensureDir $out/etc/$(dirname ${targets_[$i]})
    ln -s ${sources_[$i]} $out/etc/${targets_[$i]}
done
