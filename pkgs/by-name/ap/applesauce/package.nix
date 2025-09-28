{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "applesauce";
  version = "0.5.19";

  src = fetchFromGitHub {
    owner = "Dr-Emann";
    repo = "applesauce";
    tag = "applesauce-cli-v${finalAttrs.version}";
    hash = "sha256-OJZOB7h3qFkaCaPi+EJxIFX8q/Q38vtI0CmDK4PMD1g=";
  };

  cargoHash = "sha256-gQQpvS2LtlDBXjTqQvSUCXv5UCiQm1kiS/yPcG5KGxY=";

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
