{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  gmpxx,
  flint,
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
    flint
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

  meta = with lib; {
    homepage = "https://www.normaliz.uni-osnabrueck.de/";
    description = "Open source tool for computations in affine monoids, vector configurations, lattice polytopes, and rational cones";
    maintainers = with maintainers; [ yannickulrich ];
    platforms = with platforms; unix ++ windows;
    license = licenses.gpl3Plus;
    mainProgram = "normaliz";
  };
})
