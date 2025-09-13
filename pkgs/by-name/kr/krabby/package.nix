{
  lib,
  rustPlatform,
  fetchCrate,
}:
rustPlatform.buildRustPackage rec {
  pname = "krabby";
  version = "0.3.0";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-UcvCIazuVoqYb4iz62MrOVtQli4EqzrEpg3imv3sXHY=";
  };

  cargoHash = "sha256-aJBZtRs83KwnxlgNn/5zEGCw4YUl4mRcs1dFi2uaIrc=";

  meta = {
    description = "Print pokemon sprites in your terminal";
    homepage = "https://github.com/yannjor/krabby";
    changelog = "https://github.com/yannjor/krabby/releases/tag/v${version}";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ ruby0b ];
    mainProgram = "krabby";
  };
}
