{
  lib,
  fetchFromGitHub,
  rustPlatform,
  withCitation ? true,
}:

rustPlatform.buildRustPackage {
  pname = "simple-completion-language-server";
  version = "0-unstable-2025-07-29";

  src = fetchFromGitHub {
    owner = "estin";
    repo = "simple-completion-language-server";
    rev = "cc57b08ebc68805266beacb512a453e16f86bf17";
    hash = "sha256-TiVzgwsP1KZxTxW71eQyp1bkDnyTaMJdBYmkdvl1RX0=";
  };

  cargoHash = "sha256-M+kjdT9X69kdZcBHC2ChR7WGgxtcUaU8woE2bqhu8IM=";

  buildFeatures = lib.optional withCitation [ "citation" ];

  meta = {
    description = "Language server to enable word completion and snippets for Helix editor";
    homepage = "https://github.com/estin/simple-completion-language-server";
    license = [ lib.licenses.mit ];
    maintainers = [ lib.maintainers.kpbaks ];
    mainProgram = "simple-completion-language-server";
    platforms = lib.platforms.all;
  };
}
