{ lib, fetchCrate, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "oxker";
  version = "0.2.1";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-CsfzQN7n/LsNIivJShDG02cHwPktkXl/0udBSPz0i2U=";
  };

  cargoHash = "sha256-FSuhG+ZSQzwj1YB3xs3A1uFWPhwK8FIfVfUY9V/J2Z8=";

  meta = with lib; {
    description = "A simple tui to view & control docker containers";
    homepage = "https://github.com/mrjackwills/oxker";
    changelog = "https://github.com/mrjackwills/oxker/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ siph ];
  };
}
