. $stdenv/setup
. $makeWrapper

makeWrapper "$firefox/bin/firefox" "$out/bin/firefox" \
    --suffix-each MOZ_PLUGIN_PATH ':' "$plugins" \
    --suffix-contents LD_LIBRARY_PATH ':' "$(filterExisting $(addSuffix /extra-library-path $plugins))" \
    --suffix-contents PATH ':' "$(filterExisting $(addSuffix /extra-bin-path $plugins))"
