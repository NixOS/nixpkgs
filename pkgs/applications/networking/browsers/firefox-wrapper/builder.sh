. $stdenv/setup

mkdir -p $out/bin

pluginPath=
for i in $plugins; do
    p=$i/lib/mozilla/plugins
    if test -e $p; then
        pluginPath=$pluginPath${pluginPath:+:}$p
    fi
done

cat > $out/bin/firefox <<EOF
#! $SHELL
export MOZ_PLUGIN_PATH=$pluginPath
exec $firefox/bin/firefox
EOF

chmod +x $out/bin/firefox
