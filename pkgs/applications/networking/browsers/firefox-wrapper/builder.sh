. $stdenv/setup

mkdir -p $out/bin

pluginPath=
extraLibPath=
for i in $plugins; do
    p=$i/lib/mozilla/plugins
    if test -e $p; then
        pluginPath=$pluginPath${pluginPath:+:}$p
        if test -e $p/extra-library-path; then
            extraLibPath=$extraLibPath${extraLibPath:+:}$(cat $p/extra-library-path)
        fi
    fi
done

cat > $out/bin/firefox <<EOF
#! $SHELL
export LD_LIBRARY_PATH=$extraLibPath
export MOZ_PLUGIN_PATH=$pluginPath
exec $firefox/bin/firefox
EOF

chmod +x $out/bin/firefox
