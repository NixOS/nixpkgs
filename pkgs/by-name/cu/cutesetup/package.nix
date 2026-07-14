{
  lib,
  haskellPackages,
  fetchFromGitHub,
}:

haskellPackages.mkDerivation {
  pname = "cutesetup";
  version = "0.1.0.0";

  src = fetchFromGitHub {
    owner = "petalmaya";
    repo = "cutesetup";
    rev = "ab3cc74b5d0a7d3d3685f14d86f66d225d7c50d4";
    hash = "sha256-55kvQM2SWtK1bF+5DHaPdOBs4emVulmHkiqPA0qdAy8=";
  };

  isExecutable = true;

  executableHaskellDepends = with haskellPackages; [
    base
    brick
    vty
    vty-unix
    vty-crossplatform
    text
    containers
    microlens
    microlens-platform
    vector
    directory
    filepath
    process
    aeson
    bytestring
    async
    stm
  ];

  testHaskellDepends = with haskellPackages; [
    base
    containers
    directory
    filepath
    process
    aeson
    bytestring
    vector
    QuickCheck
  ];

  license = lib.licenses.mit;
  maintainers = [ lib.maintainers.redhood ];
  mainProgram = "cutesetup";
  description = "Cute TUI for scaffolding Nix devshells";
}
