{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "log4cplus";
  version = "2.2.0.1";

  src = fetchurl {
    url = "mirror://sourceforge/log4cplus/log4cplus-${finalAttrs.version}.tar.bz2";
    hash = "sha256-RzOWtHoFimTlsv9tUuGNnOewDEcGOfyTe5AkZRWLWzY=";
  };

  nativeBuildInputs = [ pkg-config ];

  enableParallelBuilding = true;

  strictDeps = true;

  meta = {
    homepage = "http://log4cplus.sourceforge.net/";
    description = "Port the log4j library from Java to C++";
    license = lib.licenses.asl20;
    platforms = lib.platforms.unix;
  };
})
