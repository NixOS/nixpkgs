{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libdivecomputer";
  version = "0.9.0";

  src = fetchurl {
    url = "https://www.libdivecomputer.org/releases/libdivecomputer-${finalAttrs.version}.tar.gz";
    sha256 = "sha256-p7gLkIOiETpDKA7ntR1I1m6lp3n8P+5X33xFHaAlHGU=";
  };

  enableParallelBuilding = true;

  meta = {
    homepage = "https://www.libdivecomputer.org";
    description = "Cross-platform and open source library for communication with dive computers from various manufacturers";
    mainProgram = "dctool";
    maintainers = [ lib.maintainers.mguentner ];
    license = lib.licenses.lgpl21;
    platforms = lib.platforms.all;
  };
})
