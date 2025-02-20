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
  version = "2.17";

  src = fetchurl {
    url = "mirror://sourceforge/lcms/${pname}-${version}.tar.gz";
    hash = "sha256-0Rr1aeQqG6oWUNIK1h0S5Br0/q1Kp5ZKAfk7CLU6sHQ=";
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
  LDFLAGS = if stdenv.hostPlatform.isDarwin then "-Wl,-w" else null;

  meta = with lib; {
    description = "Color management engine";
    homepage = "http://www.littlecms.com/";
    license = licenses.mit;
    platforms = platforms.all;
  };
}
