{ lib, fetchCrate, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "oxker";
  version = "0.6.4";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-dBehxqr/UCXIQDMrGFN6ID+v0NYi50JTHuML3su2O0A=";
  };

  cargoHash = "sha256-wI7yqRvaszBP4OtlWbWIZ9RLf5y7dx2KufYLaK+PWps=";

  meta = with lib; {
    description = "A simple tui to view & control docker containers";
    homepage = "https://github.com/mrjackwills/oxker";
    changelog = "https://github.com/mrjackwills/oxker/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ siph ];
    mainProgram = "oxker";
  };
}
