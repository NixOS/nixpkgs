{ lib, fetchCrate, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "oxker";
  version = "0.1.9";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-3J3Xe9LT4bHatU/wWsF0Gq9gGRcSdCzyQnIIfLXE8KA=";
  };

  cargoSha256 = "sha256-TWpshqvWMRk2A6RvjWWQc7Nu6tOrctUBZmzyjEFKPRw=";

  meta = with lib; {
    description = "A simple tui to view & control docker containers";
    homepage = "https://github.com/mrjackwills/oxker";
    changelog = "https://github.com/mrjackwills/oxker/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ siph ];
  };
}
