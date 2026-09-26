{
  lib,
  haskell,
  fetchFromGitHub,
}:

let
  # Remove when haskellPackages is on GHC 9.12
  haskellPackages = haskell.packages.ghc912;
in

haskellPackages.mkDerivation {
  pname = "hooky";
  version = "1.0.6";

  src = fetchFromGitHub {
    owner = "brandonchinn178";
    repo = "hooky";
    rev = "463904d439f7aa10c8f9a8aad1719df412166007";
    hash = "sha256-g+33B9KPKQDSoBvMpRfL1MoiE1kMml2dw/Z1GwPfyd0=";
  };

  isLibrary = true;
  isExecutable = true;
  libraryHaskellDepends = with haskellPackages; [
    base
    ansi-terminal
    bytestring
    concurrent-output
    containers
    deepseq
    directory
    file-io
    filepath
    Glob
    kdl-hs
    os-string
    process
    scientific
    text
    time
    unliftio
  ];
  executableHaskellDepends = with haskellPackages; [
    base
    containers
    directory
    file-io
    filepath
    optparse-applicative
    process
    text
    unliftio
  ];
  testHaskellDepends = with haskellPackages; [
    base
    directory
    filepath
    process
    skeletest
    temporary
    text
    unliftio
  ];
  doCheck = false;

  homepage = "https://github.com/brandonchinn178/hooky";
  description = "A minimal git hooks manager.";
  maintainers = with lib.maintainers; [ brandonchinn178 ];
  license = lib.licenses.bsd3;
  mainProgram = "hooky";
}
