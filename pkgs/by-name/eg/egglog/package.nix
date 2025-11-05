{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "egglog";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "egraphs-good";
    repo = "egglog";
    rev = "v${version}";
    hash = "sha256-j+3qknmezKqHVxvfmG9oPFtWOzJsimGXYe5PWX694mI=";
  };

  cargoHash = "sha256-gWccsWZCOucNP6M6cJqCMF8emwzqLXkaRm/huK4ARTs=";

  useNextest = true;

  meta = with lib; {
    description = "Fixpoint reasoning system that unifies Datalog and equality saturation";
    mainProgram = "egglog";
    homepage = "https://github.com/egraphs-good/egglog";
    license = licenses.mit;
    maintainers = with maintainers; [
      XBagon
    ];
  };
}
