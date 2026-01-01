{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:
rustPlatform.buildRustPackage rec {
  pname = "mdbook-footnote";
<<<<<<< HEAD
  version = "0.2.0";
=======
  version = "0.1.1";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "daviddrysdale";
    repo = "mdbook-footnote";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-YFMo+gufUEvHRnA9I98fGRXHcQjSTHY7DSRo90wcSHk=";
  };

  cargoHash = "sha256-Gr/6Et+TlVBlDf++1z3YgzqRfIolHc5qT9BwtIkjnM4=";
=======
    hash = "sha256-WUMgm1hwsU9BeheLfb8Di0AfvVQ6j92kXxH2SyG3ses=";
  };

  cargoHash = "sha256-3tuejWMZlEAOgnBKEqZP2a72a8QP1yamfE/g2BJDEbg=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

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
