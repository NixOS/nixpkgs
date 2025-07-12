{
  lib,
  stdenv,
  fetchurl,
  libclthreads,
  libX11,
  libXft,
  xorg,
  pkg-config,
}:

stdenv.mkDerivation rec {
  pname = "libclxclient";
  version = "3.9.2";

  src = fetchurl {
    url = "https://kokkinizita.linuxaudio.org/linuxaudio/downloads/clxclient-${version}.tar.bz2";
    sha256 = "10bq6fy8d3pr1x2x3xx9qhf2hdxrwdgvg843a2y6lx70y1jfj0c5";
  };

  buildInputs = [
    libclthreads
    libX11
    libXft
    xorg.xorgproto
  ];

  nativeBuildInputs = [ pkg-config ];

  env.NIX_CFLAGS_COMPILE = "-I${xorg.xorgproto}/include -I${libXft.dev}/include";

  patchPhase = ''
    cd source
    # use pkg-config instead of pkgcon:
    sed -e 's/pkgconf/pkg-config/g' -i ./Makefile
    # don't run ldconfig:
    sed -e "/ldconfig/d" -i ./Makefile
    # make sure it can find clxclient.h:
    sed -e 's/<clxclient.h>/"clxclient.h"/' -i ./enumip.cc
  '';

  makeFlags = [
    "PREFIX=$(out)"
    "SUFFIX=''"
  ];

  preInstall = ''
    # The Makefile does not create the include directory
    mkdir -p $out/include
  '';

  postInstall = ''
    ln $out/lib/libclxclient.so $out/lib/libclxclient.so.3
  '';

  meta = with lib; {
    description = "Zita X11 library";
    homepage = "http://kokkinizita.linuxaudio.org/linuxaudio/downloads/index.html";
    license = licenses.lgpl21;
    maintainers = with maintainers; [ magnetophon ];
    platforms = platforms.linux;
  };
}
