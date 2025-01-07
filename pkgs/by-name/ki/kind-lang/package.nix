{
  lib,
  mkDerivation,
  fetchFromGitHub,
  haskellPackages,
}:

mkDerivation rec {
  pname = "kind-lang";
  version = "unstable-2024-12-09";

  src = fetchFromGitHub {
    owner = "higherorderco";
    repo = "kind";
    rev = "5cfff210b3aeed01ebd73b2364cf9e5d2df658af";
    hash = "sha256-gHJ+eruwsybjRc5f1VWsof2jWQjuO/9nhOMKAvuMl7w=";
  };

  postPatch = ''
    sed -i -E \
      's/([ ,]+[^ =]+)[ =^><]+[0-9.]+/\1/' kind-lang.cabal
  '';

  isLibrary = false;
  isExecutable = true;

  libraryHaskellDepends = with haskellPackages; [
    ansi-terminal
    base
    containers
    directory
    filepath
    hs-highlight
    mtl
    parsec
  ];

  executableHaskellDepends = with haskellPackages; [
    ansi-terminal
    base
    directory
    filepath
    hs-highlight
    mtl
  ];

  # Test suite does nothing.
  doCheck = false;

  description = "A modern proof language";
  mainProgram = "kind";
  homepage = "https://github.com/higherorderco/kind";
  changelog = "https://github.com/higherorderco/kind/blob/${src.rev}/CHANGELOG.md";
  license = lib.licenses.mit;
  platforms = lib.platforms.linux;
  maintainers = with lib.maintainers; [ joaomoreira ];
}
