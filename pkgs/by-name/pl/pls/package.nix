{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "pls";
  version = "0.0.1-beta.8";

  src = fetchFromGitHub {
    owner = "pls-rs";
    repo = "pls";
    rev = "v${version}";
    hash = "sha256-gJufm2krZSTdBbbfZ+355M9e3MJQbDEpSPf0EbZEayQ=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-q6tLSq9MkWOT+XUmtv123C9VwncJ7ljTnaGEZOZqLjk=";

  meta = {
    changelog = "https://github.com/pls-rs/pls/releases/tag/${src.rev}";
    description = "Prettier and powerful ls";
    homepage = "http://pls.cli.rs";
    license = lib.licenses.gpl3Plus;
    mainProgram = "pls";
    maintainers = with lib.maintainers; [ tomasajt ];
  };
}
