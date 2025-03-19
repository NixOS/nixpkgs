{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation rec {
  pname = "gnu-cim";
  version = "5.1";

  outputs = [
    "out"
    "lib"
    "man"
    "info"
  ];

  src = fetchurl {
    url = "mirror://gnu/cim/cim-${version}.tar.gz";
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

  # lib.escapeShellArgs does not work
  env.CFLAGS = lib.concatStringsSep " " [
    "-Wno-error=implicit-function-declaration"
    "-Wno-error=implicit-int"
    "-Wno-error=return-mismatch"
    "-Wno-error=incompatible-pointer-types"
  ];

  doCheck = true;

  meta = with lib; {
    description = "GNU compiler for the programming language Simula";
    longDescription = ''
      GNU Cim is a compiler for the programming language Simula.
      It offers a class concept, separate compilation with full type checking,
      interface to external C routines, an application package for process
      simulation and a coroutine concept. Commonly used with the Demos for
      discrete event modelling.
    '';
    homepage = "https://www.gnu.org/software/cim/";
    license = licenses.gpl2;
    platforms = platforms.all;
    badPlatforms = [ "aarch64-darwin" ];
    maintainers = with maintainers; [ pbsds ];
  };
}
