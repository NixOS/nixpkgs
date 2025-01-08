{
  lib,
  stdenv,
  clang,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "eliza";
  version = "0-unstable-2025-02-21";
  src = fetchFromGitHub {
    owner = "anthay";
    repo = "ELIZA";
    rev = "27bcf6e5fb1d32812cc0aab8133fa5e395d41773";
    hash = "sha256-/i8mckRQWTK1yI/MNaieSuE+dx94DMdrABkqf/bXQbM=";
  };

  nativeBuildInputs = [
    clang
  ];

  doCheck = true;

  # Unit tests are executed automatically on execution
  checkPhase = ''
    runHook preCheck
    ./eliza --help
    runHook postCheck
  '';

  buildPhase = ''
    runHook preBuild
    clang++ -std=c++20 -pedantic -o eliza ./src/eliza.cpp
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    install -m555 ./eliza $out/bin
    runHook postInstall
  '';

  meta = {
    description = "A Simulation in C++ of Joseph Weizenbaum’s 1966 ELIZA";
    longDescription = ''
      This is an implementation in C++ of ELIZA that attempts to be as close
      to the original as possible.
      It was made to closely follow Joseph Weizenbaum’s description of his program
      given in his January 1966 Communications of the ACM paper, and later changed
      to follow the ELIZA source code found on 2021 and the SLIP programming
      function HASH(D,N) found on 2022.
      It is controlled by a script identical to the one given in the appendix of
      the 1966 paper.
    '';
    license = lib.licenses.cc0;
    mainProgram = "eliza";
    homepage = "https://github.com/anthay/ELIZA";
    maintainers = with lib.maintainers; [ EmanuelM153 ];
    platforms = lib.platforms.all;
  };
})
