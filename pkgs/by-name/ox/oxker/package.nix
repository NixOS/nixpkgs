{
  lib,
  fetchCrate,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "oxker";
  version = "0.10.2";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-szsC6EniAmcjZaSunvNY0fP3tx0hEbP6oUO0NNbjgTY=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-77oMoKzhe+vrdAwn85A6tj35EOz/ylZh5imdmRjkR3k=";

  meta = with lib; {
    description = "Simple tui to view & control docker containers";
    homepage = "https://github.com/mrjackwills/oxker";
    changelog = "https://github.com/mrjackwills/oxker/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ siph ];
    mainProgram = "oxker";
  };
}
