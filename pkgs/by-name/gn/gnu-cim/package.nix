{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gnu-cim";
  version = "5.1";

  outputs = [
    "out"
    "lib"
    "man"
    "info"
  ];

  src = fetchurl {
    url = "mirror://gnu/cim/cim-${finalAttrs.version}.tar.gz";
    hash = "sha256-uQcXtm7EAFA73WnlN+i38+ip0QbDupoIoErlc2mgaak=";
  };

  postPatch = ''
    for fname in lib/{simulation,simset}.c; do
      substituteInPlace "$fname" \
        --replace-fail \
          '#include "../../lib/cim.h"' \
          '#include "../lib/cim.h"'
    done
  '';

  env.CFLAGS = "-std=gnu89";

  doCheck = true;

  meta = {
    description = "GNU compiler for the programming language Simula";
    longDescription = ''
      GNU Cim is a compiler for the programming language Simula.
      It offers a class concept, separate compilation with full type checking,
      interface to external C routines, an application package for process
      simulation and a coroutine concept. Commonly used with the Demos for
      discrete event modelling.
    '';
    homepage = "https://www.gnu.org/software/cim/";
    license = lib.licenses.gpl2;
    platforms = lib.platforms.all;
    badPlatforms = [ "aarch64-darwin" ];
    maintainers = with lib.maintainers; [ pbsds ];
  };
})
