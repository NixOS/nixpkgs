source $stdenv/setup

mkdir -pv $out/bin/

cat > $out/bin/zathura <<EOF
#!/bin/sh
exec $zathura --plugins-dir=$plugins_path "\$@"
EOF

chmod 755 $out/bin/zathura

