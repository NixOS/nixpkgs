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
  version = "1.0.3";

  src = fetchFromGitHub {
    owner = "brandonchinn178";
    repo = "hooky";
    rev = "5ce665f376bc80948f45764bf3f2e0d590245938";
    hash = "sha256-w4sWD5dZTNKwrYhrJw9RcwGoeNxpJnm/6RRqYjiIiBg=";
  };

  isLibrary = true;
  isExecutable = true;
  libraryHaskellDepends = with haskellPackages; [
    base
    ansi-terminal
    bytestring
    concurrent-output
    containers
    directory
    filepath
    kdl-hs
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
