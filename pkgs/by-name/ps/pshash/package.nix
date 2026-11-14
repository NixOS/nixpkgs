{
  haskellPackages,
  fetchFromGitHub,
  lib,
}:
haskellPackages.mkDerivation rec {
  pname = "pshash";
  version = "0.1.23.2";
  src = fetchFromGitHub {
    owner = "thornoar";
    repo = "pshash";
    tag = "v${version}";
    hash = "sha256-YrNNisdkACO0Vnwl4nvZln+4rhUo74YRCXU8lGSAAoA=";
  };

  postPatch = ''
    patchShebangs --build test/output.sh
  '';

  isLibrary = false;
  isExecutable = true;
  doCheck = true;

  checkPhase = ''
    runHook preCheck
    test/output.sh dist/build/pshash/pshash
    runHook postCheck
  '';

  executableHaskellDepends = with haskellPackages; [
    base
    containers
    directory
    random
  ];

  license = lib.licenses.mit;
  description = "Functional pseudo-hash password creation tool";
  homepage = "https://github.com/thornoar/pshash";
  maintainers = with lib.maintainers; [ thornoar ];
  mainProgram = "pshash";
}
