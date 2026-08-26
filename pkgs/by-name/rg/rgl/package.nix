{
  lib,
  fetchFromGitHub,
  rustPlatform,
  nix-update-script,
  versionCheckHook,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "rgl";
  version = "0.18.0";

  src = fetchFromGitHub {
    owner = "ink0rr";
    repo = "rgl";
    tag = "v${finalAttrs.version}";
    hash = "sha256-UBr6yv6fDa3DhPYY/RGkCcjT15UnGa5cDJBUsCkeRjw=";
  };

  cargoHash = "sha256-6qjk6f7mclRI1X91JNlKCWonSANb2R757r5/MBPRmRA=";

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Add-on Compiler for the Bedrock Edition of Minecraft";
    homepage = "https://github.com/ink0rr/rgl";
    changelog = "https://github.com/ink0rr/rgl/releases/tag/v${finalAttrs.version}";
    license = with lib.licenses; [
      unfree
      mit
    ];
    mainProgram = "rgl";
    platforms = lib.platforms.unix ++ lib.platforms.windows;
    maintainers = with lib.maintainers; [ eveeifyeve ];
  };
})
