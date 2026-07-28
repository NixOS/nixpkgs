{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "blflash";
  version = "0.3.5";

  src = fetchFromGitHub {
    owner = "spacemeowx2";
    repo = "blflash";
    rev = "v${finalAttrs.version}";
    hash = "sha256-lv5bUbq5AnZVeR8V0A4pamY9ZIQAhLmvZEr+CRMPcj0=";
  };

  cargoHash = "sha256-9CTq/NFhc/pJ3CyvhidQxbWx5iHFbOZDPm3g7cz6uRU=";

  meta = {
    description = "Bl602 serial flasher written in Rust";
    homepage = "https://github.com/spacemeowx2/blflash";
    license = with lib.licenses; [
      mit
      asl20
    ];
    maintainers = with lib.maintainers; [ _0x4A6F ];
    mainProgram = "blflash";
  };
})
