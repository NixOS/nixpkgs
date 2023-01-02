{ lib, fetchCrate, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "oxker";
  version = "0.1.10";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-2NX2iW3cT9027j2gUsDTtdIFDmJKIGPfSzrGGwvK/VA=";
  };

  cargoSha256 = "sha256-//GI+roOsCLkKgMDUDK0YhJWmeIaYCMBt9r14+Rz8UQ=";

  meta = with lib; {
    description = "A simple tui to view & control docker containers";
    homepage = "https://github.com/mrjackwills/oxker";
    changelog = "https://github.com/mrjackwills/oxker/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ siph ];
  };
}
