{ stdenv, fetchurl, pkgconfig, libX11, libXft, libXinerama, libXpm }:

stdenv.mkDerivation rec {
  name = "dzen2-1379930259.488ab66";

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ libX11 libXft libXinerama libXpm ];

  src = fetchurl {
    url = "https://github.com/robm/dzen/tarball/master/dzen2-1379930259.488ab66git.tar.gz";
    sha256 = "0mmmacmgg2p3dsq30ga4m07qd11lvi4lns7b4pc3zhlxscy99xyl";
  };

  patchPhase = ''
    CFLAGS=" -Wall -Os ''${INCS} -DVERSION=\"''${VERSION}\" -DDZEN_XINERAMA -DDZEN_XPM -DDZEN_XFT `pkg-config --cflags xft`"
    LIBS=" -L/usr/lib -lc -lXft -lXpm -lXinerama -lX11"
    echo "CFLAGS=$CFLAGS" >>config.mk
    echo "LIBS=$LIBS" >>config.mk
    echo "LDFLAGS=$LIBS" >>config.mk
    substituteInPlace config.mk --replace /usr/local "$out"
    substituteInPlace gadgets/config.mk --replace /usr/local "$out"
  '';

  buildPhase = ''
    mkdir -p $out/bin $out/man/man1
    make clean install
    cd gadgets
    make clean install
  '';

  meta = {
    homepage = https://github.com/robm/dzen;
    license = stdenv.lib.licenses.mit;
    description = "X notification utility";
    platforms = stdenv.lib.platforms.linux;
  };
}
