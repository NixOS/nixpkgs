{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "eliza";
  version = "0-unstable-2025-04-18";
  src = fetchFromGitHub {
    owner = "anthay";
    repo = "ELIZA";
    rev = "1a185a37eb12078fa87e1034cc3eec88bfb90323";
    hash = "sha256-YhtD7tF7yGcPj6a+L1/uh+bWu+L5qiQ2bpB6gZJie2I=";
  };

  doCheck = true;

  # Unit tests are executed automatically on execution
  checkPhase = ''
    runHook preCheck
    echo Corki is mana | ./eliza
    runHook postCheck
  '';

  buildPhase = ''
    runHook preBuild
    $CXX -std=c++20 -pedantic -o eliza ./src/eliza.cpp
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    install -Dm544 ./eliza $out/bin/eliza
    runHook postInstall
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version=branch=master"
    ];
  };

  meta = {
    description = "C++ simulation of Joseph Weizenbaum’s 1966 ELIZA";
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
