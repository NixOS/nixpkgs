{
  lib,
  fetchCrate,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "oxker";
  version = "0.8.0";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-5FZDHKYv3/ZEzb0tsI7wxydDU0p7zwfhSG2i4UScf6s=";
  };

  cargoHash = "sha256-7SMIN6Nu9W6t27+YoCbJt0HCkNhw/ZU6pn6qRYvrgT8=";

  meta = with lib; {
    description = "Simple tui to view & control docker containers";
    homepage = "https://github.com/mrjackwills/oxker";
    changelog = "https://github.com/mrjackwills/oxker/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ siph ];
    mainProgram = "oxker";
  };
}
