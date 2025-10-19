{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "applesauce";
  version = "0.5.20";

  src = fetchFromGitHub {
    owner = "Dr-Emann";
    repo = "applesauce";
    tag = "applesauce-cli-v${finalAttrs.version}";
    hash = "sha256-KiivMFp772x/rFHh9PpDBjCxxC/6n6+KyAaZTmhnZV0=";
  };

  cargoHash = "sha256-WyDHp34NQi3/OotM4+4/d4ySOSYg+PDDmnLUn5R9yaU=";

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
