{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  gmpxx,
  flint,
  arb,
  nauty,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "normaliz";
  version = "3.10.4";

  src = fetchFromGitHub {
    owner = "normaliz";
    repo = "normaliz";
    rev = "v${finalAttrs.version}";
    hash = "sha256-qmbLgjAkLrW8rqFthK3H4n63zLVJ33Pe82V7yU1StOo=";
  };

  buildInputs = [
    gmpxx
    flint
    arb
    nauty
  ];

  outputs = [
    "out"
    "lib"
    "dev"
  ];

  nativeBuildInputs = [
    autoreconfHook
  ];

  meta = {
    homepage = "https://www.normaliz.uni-osnabrueck.de/";
    description = "Open source tool for computations in affine monoids, vector configurations, lattice polytopes, and rational cones";
    maintainers = with lib.maintainers; [ yannickulrich ];
    platforms = with lib.platforms; unix ++ windows;
    license = lib.licenses.gpl3Plus;
    mainProgram = "normaliz";
  };
})
