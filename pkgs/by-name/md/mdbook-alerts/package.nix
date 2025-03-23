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

  useFetchCargoVendor = true;
  cargoHash = "sha256-ZL8M9Ces8qs8ClayjJTt5FvlG+WcRpJLuZBNATEbLtQ=";

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
