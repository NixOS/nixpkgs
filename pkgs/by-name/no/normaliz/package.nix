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
  version = "3.10.3";

  src = fetchFromGitHub {
    owner = "normaliz";
    repo = "normaliz";
    rev = "v${finalAttrs.version}";
    hash = "sha256-9jN3EbYfWmir+pa4XuJpeT7CnQdhVU9pP8G11npIG00=";
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
    description = "Open source tool for computations in affine monoids, vector configurations, lattice polytopes, and rational cones";
    maintainers = with maintainers; [ yannickulrich ];
    platforms = with platforms; unix ++ windows;
    license = licenses.gpl3Plus;
    mainProgram = "normaliz";
  };
})
