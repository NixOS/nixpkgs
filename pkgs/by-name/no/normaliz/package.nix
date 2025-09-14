{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  gmpxx,
  flint3,
  nauty,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "normaliz";
  version = "3.10.5";

  src = fetchFromGitHub {
    owner = "normaliz";
    repo = "normaliz";
    rev = "v${finalAttrs.version}";
    hash = "sha256-Ku5OTtRxrs9qaSE0mle17eJSE2yKZUUsflEZk4k91jM=";
  };

  buildInputs = [
    gmpxx
    flint3
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
