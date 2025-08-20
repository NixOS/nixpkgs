{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "csv-tui";
  version = "1.2";

  src = fetchFromGitHub {
    owner = "nathangavin";
    repo = "csv-tui";
    rev = "v${version}";
    hash = "sha256-T8T9fW4E/wigktSomoc+xPkVqX5T3OnTmL4XIT5YXe8=";
  };

  cargoHash = "sha256-WDUw539G15rf2X1NWLRCHIxMqyuxthEy8Cbn5XgIFCk=";

  meta = {
    description = "Terminal based csv editor which is designed to be memory efficient but still useful";
    homepage = "https://github.com/nathangavin/csv-tui";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ottoblep ];
    mainProgram = "csv_tui";
  };
}
