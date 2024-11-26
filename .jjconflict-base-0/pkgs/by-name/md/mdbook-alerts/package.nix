{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "mdbook-alerts";
  version = "0.6.10";

  src = fetchFromGitHub {
    owner = "lambdalisue";
    repo = "rs-mdbook-alerts";
    rev = "v${version}";
    hash = "sha256-xyjLrqNb/YC2FWQXsCFJgiIDZz4xWACnrUiBuXS2Nio=";
  };

  cargoHash = "sha256-ZKnpOgTyUETCW0qxAjEj2E75mgHWLxmaTTfpdW+y3OY=";

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
