{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:
rustPlatform.buildRustPackage rec {
  pname = "mdbook-footnote";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "daviddrysdale";
    repo = "mdbook-footnote";
    tag = "v${version}";
    hash = "sha256-WUMgm1hwsU9BeheLfb8Di0AfvVQ6j92kXxH2SyG3ses=";
  };

  cargoHash = "sha256-3tuejWMZlEAOgnBKEqZP2a72a8QP1yamfE/g2BJDEbg=";

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
