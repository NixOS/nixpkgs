{
  lib,
  fetchFromGitHub,
  rustPlatform,
  nix-update-script,
  versionCheckHook,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "rgl";
  version = "0.17.0";

  src = fetchFromGitHub {
    owner = "ink0rr";
    repo = "rgl";
    tag = "v${finalAttrs.version}";
    hash = "sha256-kucD1FosCV2dxhLzxpOv/HvsqddH3NiAEVkqGTWTmGE=";
  };

  cargoHash = "sha256-/BeT18tIucgq1b5js+7QX0d1OyF5drNWMAFtv+g/XtM=";

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
