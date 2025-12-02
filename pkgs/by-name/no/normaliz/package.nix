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
  version = "3.11.0";

  src = fetchFromGitHub {
    owner = "normaliz";
    repo = "normaliz";
    rev = "v${finalAttrs.version}";
    hash = "sha256-O8zUhuR+e9yNxj9jC2xK7UZ2aUHoEWjwxn3XxTyP8hQ=";
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
