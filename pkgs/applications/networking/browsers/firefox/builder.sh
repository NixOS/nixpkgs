#! /bin/sh

buildinputs="$pkgconfig $gtk $perl $zip $libIDL"
. $stdenv/setup || exit 1

tar xvfj $src || exit 1
cd mozilla || exit 1

cat > .mozconfig <<EOF
export MOZ_PHOENIX=1
mk_add_options MOZ_PHOENIX=1
ac_add_options --enable-crypto
ac_add_options --disable-tests
ac_add_options --disable-debug
ac_add_options --disable-mailnews
ac_add_options --disable-composer
ac_add_options --enable-optimize=-O2
ac_add_options --disable-ldap
ac_add_options --disable-mailnews
ac_add_options --enable-extensions=default,-inspector,-irc,-venkman,-content-packs,-help
ac_add_options --enable-xft
ac_add_options --enable-swg
ac_add_options --enable-strip
ac_add_options --enable-default-toolkit=gtk2
EOF
echo "ac_add_options --prefix=$out" >> .mozconfig

./configure || exit 1
make -f client.mk build || exit 1
make install || exit 1
