{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:
rustPlatform.buildRustPackage rec {
  pname = "mdbook-footnote";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "daviddrysdale";
    repo = "mdbook-footnote";
    tag = "v${version}";
    hash = "sha256-YFMo+gufUEvHRnA9I98fGRXHcQjSTHY7DSRo90wcSHk=";
  };

  cargoHash = "sha256-Gr/6Et+TlVBlDf++1z3YgzqRfIolHc5qT9BwtIkjnM4=";

  meta = {
    description = "Preprocessor for mdbook to support the inclusion of automatically numbered footnotes";
    mainProgram = "mdbook-footnote";
    homepage = "https://github.com/daviddrysdale/mdbook-footnote";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      brianmcgillion
      matthiasbeyer
    ];
  };
}
