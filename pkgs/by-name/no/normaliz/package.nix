{ stdenv
, fetchFromGitHub
, autoreconfHook
, flint
, gmp
, nauty
, lib
}: stdenv.mkDerivation (final: {
  pname = "Normaliz";
  version = "3.10.1";

  src = fetchFromGitHub {
    owner = "Normaliz";
    repo = "Normaliz";
    rev = "v${final.version}";
    hash = "sha256-nnSauTlS5R6wbaoGxR6HFacFYm5r4DAhoP9IVe4ajdc=";
  };

  nativeBuildInputs = [
    autoreconfHook
  ];

  buildInputs = [
    flint
    gmp
    nauty
  ];

  enableParallelBuilding = true;

  meta = with lib; {
    description = "An open source tool for computations in affine monoids, vector configurations, lattice polytopes, and rational cones";
    homepage = "https://www.normaliz.uni-osnabrueck.de/";
    license = with licenses; [ gpl3Plus ];
    mainProgram = "normaliz";
    maintainers = with maintainers; [ alois31 ];
    sourceProvenance = with sourceTypes; [ fromSource ];
  };
})
