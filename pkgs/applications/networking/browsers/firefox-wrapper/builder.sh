. $stdenv/setup
. $makeWrapper

shopt -s nullglob

pluginPath=
extraLibPath=
for p in $plugins; do
    if test -e $p; then
        pluginPath=$pluginPath${pluginPath:+:}$p
        if test -e $p/extra-library-path; then
            extraLibPath=$extraLibPath${extraLibPath:+:}$(cat $p/extra-library-path)
        fi
    fi
done

makeWrapper "$firefox/bin/firefox" "$out/bin/firefox" \
    --suffix MOZ_PLUGIN_PATH ':' "$pluginPath" \
    --suffix LD_LIBRARY_PATH ':' "$extraLibPath"

#    --add-to-env MOZ_PLUGIN_PATH ':' --each lib/mozilla/plugins "$plugins" \
#    --add-to-env MOZ_PLUGIN_PATH ':' --each 'jre/plugin/*/mozilla' "$plugins" \
#    --add-to-env LD_LIBRARY_PATH --contents lib/mozilla/plugins/extra-library-path "$plugins" \
#    --add-to-env LD_LIBRARY_PATH --contents 'jre/plugin/*/mozilla/extra-library-path' "$plugins"

#cat > $out/bin/firefox <<EOF
##! $SHELL
#export LD_LIBRARY_PATH=$extraLibPath
#export MOZ_PLUGIN_PATH=$pluginPath
#exec $firefox/bin/firefox "\$@"
#EOF

#chmod +x $out/bin/firefox
