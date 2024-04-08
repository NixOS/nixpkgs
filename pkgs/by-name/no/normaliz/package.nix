{ lib
, stdenv
, fetchFromGitHub
, autoreconfHook
, gmpxx
, flint
, arb
, nauty
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "normaliz";
  version = "3.10.1";

  src = fetchFromGitHub {
    owner = "normaliz";
    repo = "normaliz";
    rev = "v${finalAttrs.version}";
    hash = "sha256-nnSauTlS5R6wbaoGxR6HFacFYm5r4DAhoP9IVe4ajdc=";
  };

  buildInputs = [
    gmpxx
    flint
    arb
    nauty
  ];

  outputs = [ "out" "lib" "dev" ];

  nativeBuildInputs = [
    autoreconfHook
  ];

  meta = with lib; {
    homepage = "https://www.normaliz.uni-osnabrueck.de/";
    description = "An open source tool for computations in affine monoids, vector configurations, lattice polytopes, and rational cones";
    maintainers = with maintainers; [ yannickulrich ];
    platforms = with platforms; unix ++ windows;
    license = licenses.gpl3Plus;
    mainProgram = "normaliz";
  };
})
