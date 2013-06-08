source $stdenv/setup

mkdir -pv $out/bin/
mkdir -pv $out/share/
mkdir -pv $out/share/applications/
mkdir -pv $out/share/pixmaps/

cat > $out/bin/zathura <<EOF
#!/bin/sh
exec $zathura_core/bin/zathura --plugins-dir=$plugins_path "\$@"
EOF

cp -rv $zathura_core/share/man $out/share
cp -rv $zathura_core/share/locale $out/share
cp -rv $icon $out/share/pixmaps/pwmt.xpm

cat $zathura_core/share/applications/zathura.desktop > $out/share/applications/zathura.desktop
echo "Icon=pwmt" >> $out/share/applications/zathura.desktop

chmod 755 $out/bin/zathura

