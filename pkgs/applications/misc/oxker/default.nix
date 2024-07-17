{
  lib,
  fetchCrate,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "oxker";
  version = "0.6.3";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-L03r4PHCu+jsUC5vVSG77SR2ak/AsuVAhTd7P1WibAk=";
  };

  cargoHash = "sha256-5UxbZZdVioy1OZCbE6qESGKVnVT6TS4VHzsKlQ8XP2c=";

  meta = with lib; {
    description = "A simple tui to view & control docker containers";
    homepage = "https://github.com/mrjackwills/oxker";
    changelog = "https://github.com/mrjackwills/oxker/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ siph ];
    mainProgram = "oxker";
  };
}
