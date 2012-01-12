source $stdenv/setup

die() { echo $@ >&2 ; exit 1; }

tar xvfz $src

cd dzen2-* || die

patchPhase || die

cat config.mk | \
	sed "s@X11INC = SETME@X11INC = $libX11/include@g" | \
	sed "s@X11LIB = SETME@X11LIB = $libX11/lib@g" | \
	sed "s@XINERAMAINC = SETME@XINERAMAINC = $libXinerama/include@g" | \
	sed "s@XINERAMALIB = SETME@XINERAMALIB = $libXinerama/lib@g" | \
	sed "s@XPMINC = SETME@XPMINC = $libXpm/include@g" | \
	sed "s@XPMLIB = SETME@XPMLIB = $libXpm/lib@g" | \
	sed "s@PREFIX = SETME@PREFIX = $out@g" | \
	cat > config.mk.new || die

mv config.mk.new config.mk || die

make || die

make install || die

cd gadgets || die

cat config.mk | \
	sed "s@PREFIX = /usr/local@PREFIX = $out@g" | \
	cat > config.mk.new || die
mv config.mk.new config.mk || die

make || die

make install || die

