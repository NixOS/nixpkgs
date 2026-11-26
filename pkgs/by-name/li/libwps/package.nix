{
  lib,
  stdenv,
  fetchurl,
  boost,
  pkg-config,
  librevenge,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libwps";
  version = "0.4.15";

  src = fetchurl {
    url = "mirror://sourceforge/libwps/libwps-${finalAttrs.version}.tar.bz2";
    sha256 = "sha256-zkgZeQ/eGwsJhQCDofwwP23Gjs0r3nXHSj+ouosNb/I=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    boost
    librevenge
    zlib
  ];

  env.NIX_CFLAGS_COMPILE = "-Wno-error=implicit-fallthrough";

  meta = {
    homepage = "https://libwps.sourceforge.net/";
    description = "Microsoft Works document format import filter library";
    platforms = lib.platforms.unix;
    license = lib.licenses.lgpl21;
  };
})
