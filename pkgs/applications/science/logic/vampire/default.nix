{
  lib,
  stdenv,
  fetchFromGitHub,
  z3,
  zlib,
}:

stdenv.mkDerivation rec {
  pname = "vampire";
  version = "4.9";

  src = fetchFromGitHub {
    owner = "vprover";
    repo = "vampire";
    tag = "v${version}casc2024";
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

  postPatch = ''
    patch -p1 -i ${./minisat-fenv.patch} -d Minisat || true
  '';

  enableParallelBuilding = true;

  fixupPhase = ''
    runHook preFixup

    rm -rf z3

    runHook postFixup
  '';

  installPhase = ''
    runHook preInstall

    install -m0755 -D vampire_z3_rel* $out/bin/vampire

    runHook postInstall
  '';

  meta = {
    homepage = "https://vprover.github.io/";
    description = "Vampire Theorem Prover";
    mainProgram = "vampire";
    platforms = lib.platforms.unix;
    license = lib.licenses.bsd3;
    maintainers = [ ];
  };
}
