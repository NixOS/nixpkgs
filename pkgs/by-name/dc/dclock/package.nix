{
  lib,
  stdenv,
  fetchFromGitHub,
  haskellPackages,
}:

haskellPackages.mkDerivation {
  pname = "dclock";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "travgm";
    repo = "dclock";
    rev = "main";
    sha256 = "sha256-IJsbEg1dFiyIJSlVWy8x+tsa49YxLK8mNkJESFyUQoU=";
  };

  isLibrary = false;
  isExecutable = true;
  jailbreak = true;
  doCheck = false;

  executableHaskellDepends = with haskellPackages; [
    base
    QuickCheck
    ansi-terminal
    hspec
    hspec-discover
    lens
    machines
    optparse-applicative
    text
    time
    process
  ];

  description = "Decimal clock that breaks your day into a 1000 decimal minutes";
  homepage = "https://github.com/travgm/dclock";
  license = lib.licenses.mit;
  maintainers = with lib.maintainers; [ travgm ];
  mainProgram = "dclock";
}
