{
  lib,
  stdenv,
  fetchurl,
  cups,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "cups-bjnp";
  version = "2.0.3";

  src = fetchurl {
    url = "mirror://sourceforge/cups-bjnp/cups-bjnp-${finalAttrs.version}.tar.gz";
    hash = "sha256-yRSy/Z2OJs4i8t9iRNne/uwx7ppTYPcj7ss7APIWhQA=";
  };

  preConfigure = ''
    mkdir -p $out/lib/cups/backend
    configureFlags="--with-cupsbackenddir=$out/lib/cups/backend"
  '';

  buildInputs = [ cups ];

  env.NIX_CFLAGS_COMPILE = toString [
    "-include stdio.h"
    "-Wno-error=stringop-truncation"
    "-Wno-error=deprecated-declarations"
    "-Wno-unused-variable"
    "-Wno-error=address"
    "-Wno-error=dangling-pointer"
  ];

  meta = {
    description = "CUPS back-end for Canon printers";
    longDescription = ''
      CUPS back-end for the canon printers using the proprietary USB over IP
      BJNP protocol. This back-end allows Cups to print over the network to a
      Canon printer. The design is based on reverse engineering of the protocol.
    '';
    homepage = "http://cups-bjnp.sourceforge.net";
    platforms = lib.platforms.linux;
  };
})
