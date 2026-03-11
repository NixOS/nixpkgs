{
  stdenv,
  lib,
  fetchurl,
  pkg-config,
  guile,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "guile-quickcheck";
  version = "0.1.0";

  src = fetchurl {
    url = "https://files.ngyro.com/guile-quickcheck/guile-quickcheck-${finalAttrs.version}.tar.gz";
    hash = "sha256-y5msW+mbQ7YeucRS2VNUPokOKoP8g6ysKJ2UMWiIvA4=";
  };

  strictDeps = true;
  nativeBuildInputs = [
    guile
    pkg-config
  ];
  buildInputs = [ guile ];

  doCheck = !stdenv.hostPlatform.isDarwin;

  meta = {
    homepage = "https://ngyro.com/software/guile-quickcheck.html";
    description = "Guile library providing tools for randomized, property-based testing";
    license = lib.licenses.gpl3Plus;
    maintainers = [ ];
    platforms = guile.meta.platforms;
  };
})
