source $stdenv/setup

ensureDir $out
cat >> $out/install <<EOF
#! /bin/sh

PLUGIN=$plugin
UNZIP=$unzip/bin/unzip
ECLIPSE=\$1

\$UNZIP \$PLUGIN

if test -e plugins; then
  cp -prd * \$ECLIPSE
else
  cd *
  cp -prd * \$ECLIPSE
fi
EOF

chmod u+x $out/install
