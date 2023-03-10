{ lib, stdenv, fetchurl, gnused, openssl, curl, ncurses, libjpeg
, withGpg ? true, gpgme ? null}:

stdenv.mkDerivation rec {
  version = "5.0.1";
  pname = "centerim5";

  src = fetchurl {
    url = "http://centerim.org/download/cim5/${pname}-${version}.tar.gz";
    sha256 = "0viz86jflp684vfginhl6aaw4gh2qvalc25anlwljjl3kkmibklk";
  };

  CXXFLAGS = "-std=gnu++98";

  buildInputs = [ openssl curl ncurses libjpeg ]
    ++ lib.optional withGpg gpgme;

  preConfigure = ''
    ${gnused}/bin/sed -i '1,1i#include <stdio.h>' libicq2000/libicq2000/sigslot.h
  '';

  configureFlags = [
    "--with-openssl=${openssl.dev}"
  ];

  meta = {
    homepage = "https://www.centerim.org/";
    description = "Fork of CenterICQ, a curses instant messaging program";
    license = lib.licenses.gpl2Plus;
    platforms = with lib.platforms; linux;
  };
}
