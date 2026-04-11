{
  haskellPackages,
  fetchFromGitHub,
  lib,
}:

haskellPackages.mkDerivation rec {
  pname = "nota";
  version = "1.0-unstable-2023-03-01";

  src = fetchFromGitHub {
    owner = "pouyakary";
    repo = "Nota";
    rev = "3548b864e5aa30ffbf1704a79dbb3bd3aab813be";
    hash = "sha256-96T9uxUEV22/vn6aoInG1UPXbzlDHswOSkywkdwsMeY=";
  };

  sourceRoot = "${src.name}/source";

  isLibrary = false;
  isExecutable = true;

  libraryHaskellDepends = with haskellPackages; [
    base
    bytestring
    array
    split
    scientific
    parsec
    ansi-terminal
    regex-compat
    containers
    terminal-size
    numbers
    text
    time
  ];

  description = "Command line calculator";
  homepage = "https://pouyakary.org/nota/";
  license = lib.licenses.mpl20;
  maintainers = [ ];
  mainProgram = "nota";
}
