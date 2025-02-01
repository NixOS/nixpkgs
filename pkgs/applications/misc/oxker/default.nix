{ lib, fetchCrate, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "oxker";
  version = "0.7.2";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-Qh/mUEfCvrOrUHJ1kEWb3BLBmMyP/MzUyfFoB+eYj9w=";
  };

  cargoHash = "sha256-VYA5Y6CjhKx3MgQ0pyOO7vw44cKykRjlgUZopgR9pYo=";

  meta = with lib; {
    description = "Simple tui to view & control docker containers";
    homepage = "https://github.com/mrjackwills/oxker";
    changelog = "https://github.com/mrjackwills/oxker/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ siph ];
    mainProgram = "oxker";
  };
}
