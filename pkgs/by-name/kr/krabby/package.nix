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

  cargoHash = "sha256-BMePUHbn/PdXw63PBQNB+ER7l1y5DhWInjBWaGtXCYU=";

  meta = with lib; {
    description = "Print pokemon sprites in your terminal";
    homepage = "https://github.com/yannjor/krabby";
    changelog = "https://github.com/yannjor/krabby/releases/tag/v${version}";
    license = licenses.gpl3;
    maintainers = with maintainers; [ ruby0b ];
    mainProgram = "krabby";
  };
}
