{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "applesauce";
  version = "0.5.30";

  src = fetchFromGitHub {
    owner = "Dr-Emann";
    repo = "applesauce";
    tag = "applesauce-cli-v${finalAttrs.version}";
    hash = "sha256-YDgRDVy5/x8ccJtV3v3YKqAQJVP7vMgNY5n5uFGJR2I=";
  };

  cargoHash = "sha256-hpcPoNLQya4ufXbkbxzm1T3aUXyk1jdAiTrxKtfbQx8=";

  meta = {
    description = "Transparent compression for Apple File System Compression (AFSC)";
    homepage = "https://github.com/Dr-Emann/applesauce";
    changelog = "https://github.com/Dr-Emann/applesauce/releases/tag/applesauce-cli-v${finalAttrs.version}";
    license = with lib.licenses; [
      gpl3Plus
    ];
    maintainers = with lib.maintainers; [
      maxicode
    ];
    mainProgram = "applesauce";
    platforms = lib.platforms.darwin;
  };
})
