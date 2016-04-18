{ stdenv, fetchurl, fetchpatch, cmake, pkgconfig, python
, libX11, libXpm, libXft, libXext, zlib }:

stdenv.mkDerivation rec {
  name = "root-${version}";
  version = "6.04.16";

  src = fetchurl {
    url = "https://root.cern.ch/download/root_v${version}.source.tar.gz";
    sha256 = "0f58dg83aqhggkxmimsfkd1qyni2vhmykq4qa89cz6jr9p73i1vm";
  };

  buildInputs = [ cmake pkgconfig python libX11 libXpm libXft libXext zlib ];

  cmakeFlags = "-Drpath=ON";

  enableParallelBuilding = true;

  meta = {
    homepage = "http://root.cern.ch/drupal/";
    description = "A data analysis framework";
    platforms = stdenv.lib.platforms.linux;
  };
}
