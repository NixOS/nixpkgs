{
  lib,
  stdenv,
  fetchurl,
  expat,
  zlib,
  boost,
  libiconv,
}:

stdenv.mkDerivation rec {
  pname = "exempi";
  version = "2.6.6";

  src = fetchurl {
    url = "https://libopenraw.freedesktop.org/download/${pname}-${version}.tar.bz2";
    sha256 = "sha256-dRO35Cw72QpY132TjGDS6Hxo+BZG58uLEtcf4zQ5HG8=";
  };

  configureFlags = [
    "--with-boost=${boost.dev}"
  ]
  ++ lib.optionals (!doCheck) [
    "--enable-unittest=no"
  ];

  buildInputs = [
    expat
    zlib
    boost
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    libiconv
  ];

  doCheck = stdenv.hostPlatform.isLinux && stdenv.hostPlatform.is64bit;
  dontDisableStatic = doCheck;

  enableParallelBuilding = true;

  meta = with lib; {
    description = "Implementation of XMP (Adobe's Extensible Metadata Platform)";
    mainProgram = "exempi";
    homepage = "https://libopenraw.freedesktop.org/exempi/";
    platforms = platforms.linux ++ platforms.darwin;
    license = licenses.bsd3;
  };
}
