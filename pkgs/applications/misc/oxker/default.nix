{ lib, fetchCrate, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "oxker";
  version = "0.2.4";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-wYGaBXorAcwFnlUixrOP63s32WV1V7/8SUOBXIeLB7o=";
  };

  cargoHash = "sha256-rdzr6oOrJNTX3dCSO3ZdKNFZ31/CHdupKL7QmmuuX7I=";

  meta = with lib; {
    description = "A simple tui to view & control docker containers";
    homepage = "https://github.com/mrjackwills/oxker";
    changelog = "https://github.com/mrjackwills/oxker/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ siph ];
  };
}
