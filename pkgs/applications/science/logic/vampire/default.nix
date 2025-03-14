{
  lib,
  stdenv,
  fetchFromGitHub,
  z3,
  zlib,
}:

stdenv.mkDerivation {
  pname = "vampire";
  version = "4.9";

  src = fetchFromGitHub {
    owner = "vprover";
    repo = "vampire";
    tag = "v4.9casc2024";
    hash = "sha256-NHAlPIy33u+TRmTuFoLRlPCvi3g62ilTfJ0wleboMNU=";
  };

  buildInputs = [
    z3
    zlib
  ];

  makeFlags = [
    "vampire_z3_rel"
    "CC:=$(CC)"
    "CXX:=$(CXX)"
  ];

  enableParallelBuilding = true;

  fixupPhase = ''
    rm -rf z3
  '';

  installPhase = ''
    install -m0755 -D vampire_z3_rel* $out/bin/vampire
  '';

  meta = with lib; {
    homepage = "https://vprover.github.io/";
    description = "Vampire Theorem Prover";
    mainProgram = "vampire";
    platforms = platforms.unix;
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
  };
}
