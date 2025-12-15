{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  libX11,
  libXft,
  libXinerama,
  libXpm,
}:

stdenv.mkDerivation rec {
  pname = "dzen2";
  version = "0.9.5";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    libX11
    libXft
    libXinerama
    libXpm
  ];

  src = fetchurl {
    url = "https://github.com/robm/dzen/tarball/master/dzen2-${version}git.tar.gz";
    sha256 = "d4f7943cd39dc23fd825eb684b49dc3484860fa8443d30b06ee38af72a53b556";
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
    homepage = "https://github.com/robm/dzen";
    license = lib.licenses.mit;
    description = "X notification utility";
    platforms = lib.platforms.linux;
  };
}
