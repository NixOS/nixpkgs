{ lib, fetchCrate, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "oxker";
  version = "0.6.0";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-s1PVm5RBqHe5XVHt5Wgm05+6xXJYnMU9QO7Z8567oKk=";
  };

  cargoHash = "sha256-zZFys59vEiGfB9NlAY5yjHBeXf8zQ3npFF7sg2SQTwU=";

  meta = with lib; {
    description = "A simple tui to view & control docker containers";
    homepage = "https://github.com/mrjackwills/oxker";
    changelog = "https://github.com/mrjackwills/oxker/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ siph ];
  };
}
