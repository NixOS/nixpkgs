{
  lib,
  rustPlatform,
  fetchCrate,
}:
rustPlatform.buildRustPackage rec {
  pname = "krabby";
  version = "0.2.2";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-BmTx2kpnibTVuutAIrpFTTOGpO6WzITb6SXwUKuMtYY=";
  };

  cargoHash = "sha256-gZzjx4JWe3CcG8wuQRTYjyEvvhCyUBXHQSw5sYhih9o=";

  meta = with lib; {
    description = "Print pokemon sprites in your terminal";
    homepage = "https://github.com/yannjor/krabby";
    changelog = "https://github.com/yannjor/krabby/releases/tag/v${version}";
    license = licenses.gpl3;
    maintainers = with maintainers; [ ruby0b ];
    mainProgram = "krabby";
  };
}
