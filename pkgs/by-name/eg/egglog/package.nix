{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage {
  pname = "egglog";
  version = "0-unstable-2024-01-26";

  src = fetchFromGitHub {
    owner = "egraphs-good";
    repo = "egglog";
    rev = "b78f69ca1f7187c363bb31271c8e8958f477f15d";
    hash = "sha256-/1ktyz8wU1yLTdAFPnupK6jUFjiK6nQfotGRNOWiOsA=";
  };

  useNextest = true;

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "generic_symbolic_expressions-5.0.3" = "sha256-UX6fS470YJMdNnn0GR3earMGQK3p/YvaFia7IEvGGKg=";
    };
  };

  meta = with lib; {
    description = "Fixpoint reasoning system that unifies Datalog and equality saturation";
    mainProgram = "egglog";
    homepage = "https://github.com/egraphs-good/egglog";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
  };
}
