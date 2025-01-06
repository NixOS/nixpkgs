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

  meta = {
    description = "Print pokemon sprites in your terminal";
    homepage = "https://github.com/yannjor/krabby";
    changelog = "https://github.com/yannjor/krabby/releases/tag/v${version}";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ ruby0b ];
    mainProgram = "krabby";
  };
}
