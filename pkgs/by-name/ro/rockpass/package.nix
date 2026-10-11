{
  lib,
  fetchFromGitLab,
  rustPlatform,
  sqlite,
}:

rustPlatform.buildRustPackage rec {
  pname = "rockpass";
  version = "0.12.0";

  src = fetchFromGitLab {
    owner = "ogarcia";
    repo = "rockpass";
    tag = version;
    hash = "sha256-miCageYfAvDfg9hICeQCQg1rzBqbxusa8dCmknYFeZE=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-89l9+C0pWVSvETTIOOG7ALo5AZKDU5DkX3lmGtO2hBk=";

  buildInputs = [
    sqlite
  ];

  meta = {
    description = "A small and ultrasecure LessPass database API server written in Rust";
    homepage = "https://gitlab.com/ogarcia/rockpass";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ arbel-arad ];
    mainProgram = "rockpass";
  };
}
