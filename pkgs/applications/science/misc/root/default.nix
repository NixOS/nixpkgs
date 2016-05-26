{ stdenv, fetchurl, fetchpatch, cmake, pkgconfig, python
, libX11, libXpm, libXft, libXext, zlib, lzma }:

stdenv.mkDerivation rec {
  name = "root-${version}";
  version = "6.04.16";

  src = fetchurl {
    url = "https://root.cern.ch/download/root_v${version}.source.tar.gz";
    sha256 = "0f58dg83aqhggkxmimsfkd1qyni2vhmykq4qa89cz6jr9p73i1vm";
  };

  buildInputs = [ cmake pkgconfig python libX11 libXpm libXft libXext zlib lzma ];

  preConfigure = ''
    patchShebangs build/unix/
  '';

  cmakeFlags = [
    "-Drpath=ON"
    "-DCMAKE_INSTALL_LIBDIR=lib"
    "-DCMAKE_INSTALL_INCLUDEDIR=include"
  ]
  ++ stdenv.lib.optional (stdenv.cc.libc != null) "-DC_INCLUDE_DIRS=${stdenv.cc.libc}/include";

  meta = {
    homepage = "https://root.cern.ch/";
    description = "A data analysis framework";
    platforms = stdenv.lib.platforms.linux;
  };
}
