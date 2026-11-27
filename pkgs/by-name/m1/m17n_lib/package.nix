{
  lib,
  stdenv,
  fetchurl,
  m17n_db,
  autoreconfHook,
  pkg-config,
  testers,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "m17n-lib";
  version = "1.8.6";

  src = fetchurl {
    url = "mirror://savannah/m17n/m17n-lib-${finalAttrs.version}.tar.gz";
    hash = "sha256-cSn+O3rVAPiLivhgXvB7lsh6deyYamlf/8CkCfRKfIY=";
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

  passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;

  __structuredAttrs = true;

  meta = {
    homepage = "https://www.nongnu.org/m17n/";
    description = "Multilingual text processing library (runtime)";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.linux;
    pkgConfigModules = [
      "m17n-core"
      "m17n-flt"
      "m17n-gui"
      "m17n-shell"
    ];
  };
})
