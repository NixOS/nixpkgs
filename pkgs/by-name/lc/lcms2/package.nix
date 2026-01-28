{
  lib,
  stdenv,
  fetchurl,
  libtiff,
  libjpeg,
  zlib,
}:

stdenv.mkDerivation rec {
  pname = "lcms2";
  version = "2.18";

  src = fetchurl {
    url = "mirror://sourceforge/lcms/${pname}-${version}.tar.gz";
    hash = "sha256-7me+NWb0WTYsHuCU/eLBWdM/oDkKpO1fWvZ2+eUAQ0c=";
  };

  outputs = [
    "bin"
    "dev"
    "out"
  ];

  buildInputs = [
    libtiff
    libjpeg
    zlib
  ];

  # See https://trac.macports.org/ticket/60656
  env = lib.optionalAttrs stdenv.hostPlatform.isDarwin { LDFLAGS = "-Wl,-w"; };

  meta = {
    description = "Color management engine";
    homepage = "http://www.littlecms.com/";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
  };
}
