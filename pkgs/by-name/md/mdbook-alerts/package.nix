{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "mdbook-alerts";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "lambdalisue";
    repo = "rs-mdbook-alerts";
    rev = "v${version}";
    hash = "sha256-MZS9TESITj3tzdaXYu5S2QUCW7cZuTpH1skFKeVi/sQ=";
  };

  cargoHash = "sha256-twAIr1GVkvo4ZC7iwgKY4L1CklGVvGqd/eQf8toncDE=";

  meta = {
    description = "Preprocessor for mdbook to support the inclusion of Markdown alerts";
    mainProgram = "mdbook-alerts";
    homepage = "https://github.com/lambdalisue/rs-mdbook-alerts";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      brianmcgillion
      matthiasbeyer
    ];
  };
}
