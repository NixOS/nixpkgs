{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "applesauce";
  version = "0.5.21";

  src = fetchFromGitHub {
    owner = "Dr-Emann";
    repo = "applesauce";
    tag = "applesauce-cli-v${finalAttrs.version}";
    hash = "sha256-Dd1gfjtg1kEXyDakIoAkbu+iiRafykPO39z7tMJylkM=";
  };

  cargoHash = "sha256-fx/D5Bt5YKySJXZRBHlJlAiFWu5++JXgHK1jSKvWEiA=";

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
