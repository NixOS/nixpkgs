{
  lib,
  rustPlatform,
  fetchCrate,
}:

rustPlatform.buildRustPackage rec {
  pname = "pulldown-cmark";
  version = "0.13.0";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-lp0ywX/3phfC30QvYkO2wFZNSinP4cdm4HY744EZ02o=";
  };

  cargoHash = "sha256-ek6Eczqb/kxxoZFakGcwrgqXAtNCtQxDX2PHdOcIUjU=";

  meta = {
    description = "Pull parser for CommonMark written in Rust";
    homepage = "https://github.com/raphlinus/pulldown-cmark";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ CobaltCause ];
    mainProgram = "pulldown-cmark";
  };
}
