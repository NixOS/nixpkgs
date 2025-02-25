{
  lib,
  stdenv,
  fetchurl,
  cups,
}:

stdenv.mkDerivation rec {
  pname = "cups-bjnp";
  version = "1.2.2";

  src = fetchurl {
    url = "mirror://sourceforge/cups-bjnp/cups-bjnp-${version}.tar.gz";
    sha256 = "0sb0vm1sf8ismzd9ba33qswxmsirj2z1b7lnyrc9v5ixm7q0bnrm";
  };

  preConfigure = ''configureFlags="--with-cupsbackenddir=$out/lib/cups/backend"'';

  buildInputs = [ cups ];
  env.NIX_CFLAGS_COMPILE = toString [
    "-include stdio.h"
    "-Wno-error=stringop-truncation"
    "-Wno-error=deprecated-declarations"
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
}
