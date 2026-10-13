{
  lib,
  stdenv,
  fetchurl,
  m17n_db,
  autoreconfHook,
  pkg-config,
}:
stdenv.mkDerivation rec {
  pname = "m17n-lib";
  version = "1.8.7";

  src = fetchurl {
    url = "mirror://savannah/m17n/${pname}-${version}.tar.gz";
    hash = "sha256-pyz3jkAZgCCqBSF7mDndJguU1PLcWaWo1guue4QQTKo=";
  };

  strictDeps = true;

  # reconf needed to successfully cross-compile
  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    # requires m17n-db tool at build time
    m17n_db
  ];

  enableParallelBuilding = true;

  meta = {
    homepage = "https://www.nongnu.org/m17n/";
    description = "Multilingual text processing library (runtime)";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.linux;
  };
}
