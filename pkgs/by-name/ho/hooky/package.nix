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
  version = "1.0.5";

  src = fetchFromGitHub {
    owner = "brandonchinn178";
    repo = "hooky";
    rev = "ff70af91b46fb3ecadd9f8444907ae67b3b69306";
    hash = "sha256-Nuc4j17Ra1/6Tg01gaep8Z6TDOTowG3YLb0ZRZOuIaE=";
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
