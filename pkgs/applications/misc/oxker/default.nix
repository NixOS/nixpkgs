{ lib, fetchCrate, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "oxker";
  version = "0.3.2";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-HFZSIzP3G6f78gTOpzZFG5ZAo5Lo6VuxQe6xMvCVfss=";
  };

  cargoHash = "sha256-ZsqxlwgXqw9eUEjw1DLBMz05V/y/ZbcrCL6I8TcnnDs=";

  meta = with lib; {
    description = "A simple tui to view & control docker containers";
    homepage = "https://github.com/mrjackwills/oxker";
    changelog = "https://github.com/mrjackwills/oxker/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ siph ];
  };
}
