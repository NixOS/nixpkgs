{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation rec {
  pname = "lcms";
  version = "1.19";

  src = fetchurl {
    url = "mirror://sourceforge/lcms/${pname}-${version}.tar.gz";
    sha256 = "1abkf8iphwyfs3z305z3qczm3z1i9idc1lz4gvfg92jnkz5k5bl0";
  };

  patches = [ ./cve-2013-4276.patch ];

  env = lib.optionalAttrs stdenv.cc.isGNU {
    NIX_CFLAGS_COMPILE = "-Wno-error=implicit-function-declaration";
  };

  outputs = [
    "bin"
    "dev"
    "out"
    "man"
  ];

  doCheck = false; # fails with "Error in Linear interpolation (2p): Must be i=8000, But is n=8001"

  meta = {
    description = "Color management engine";
    homepage = "http://www.littlecms.com/";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
  };
}
