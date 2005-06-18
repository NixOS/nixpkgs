. $stdenv/setup

preConfigure() {
    cat mail/config/mozconfig > .mozconfig
    cat >> .mozconfig <<EOF
ac_add_options --disable-debug
ac_add_options --enable-optimize=-O2
ac_add_options --disable-ldap
ac_add_options --enable-xft
ac_add_options --disable-freetype2
ac_add_options --enable-swg
ac_add_options --enable-strip
ac_add_options --enable-default-toolkit=gtk2
ac_add_options --enable-single-profile
ac_add_options --prefix=$out
EOF
}

preConfigure=preConfigure

makeFlags="-f client.mk build"

genericBuild
