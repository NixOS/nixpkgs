{
  lib,
  stdenv,
  fetchurl,
  gmp,
  mpfr,
  boost,
  version ? "1.6.0",
}:

stdenv.mkDerivation {
  pname = "gappa";
  inherit version;

  src = fetchurl {
    url = "https://gappa.gitlabpages.inria.fr/releases/gappa-${version}.tar.gz";
    hash = "sha256-aNht0Ttv+gzS9eLzu4PQitRK/zQN9QQ4YOEjQ2d9xIM=";
  };

  buildInputs = [
    gmp
    mpfr
    boost.dev
  ];

  buildPhase = "./remake";
  installPhase = "./remake install";

  meta = {
    homepage = "https://gappa.gitlabpages.inria.fr/";
    description = "Verifying and formally proving properties on numerical programs dealing with floating-point or fixed-point arithmetic";
    mainProgram = "gappa";
    license = with lib.licenses; [
      cecill21
      gpl3
    ];
    maintainers = with lib.maintainers; [ vbgl ];
    platforms = lib.platforms.all;
  };
}
