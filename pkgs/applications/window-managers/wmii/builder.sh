source $stdenv/setup

postUnpack() {
cd $sourceRoot

cat >> config.mk << EOF
PREFIX=
DESTDIR=${out}

CFLAGS = -DVERSION=\\"\${VERSION}\\"

LDFLAGS = -lm -lX11 -lixp

AWKPATH=${gawk}/bin/gawk
CONFPREFIX = /etc
MANPREFIX = /share/man
EOF

cd ..
}

postUnpack=postUnpack

genericBuild
