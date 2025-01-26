{
  lib,
  haskellPackages,
  fetchFromGitHub,
}:

haskellPackages.mkDerivation {
  pname = "lngen";
  version = "unstable-2024-10-22";
  src = fetchFromGitHub {
    owner = "plclub";
    repo = "lngen";
    rev = "c034c8d95264e6a5d490bc4096534ccd54f0d393";
    hash = "sha256-XzcB/mNXure6aZRmwgUWGHSEaknrbP8Onk2CisVuhiw=";
  };
  isLibrary = true;
  isExecutable = true;
  libraryHaskellDepends = with haskellPackages; [
    base
    syb
    parsec
    containers
    mtl
  ];
  executableHaskellDepends = with haskellPackages; [ base ];
  homepage = "https://github.com/plclub/lngen";
  description = "Tool for generating Locally Nameless definitions and proofs in Coq, working together with Ott";
  maintainers = with lib.maintainers; [ chen ];
  license = lib.licenses.mit;
  mainProgram = "lngen";
}
