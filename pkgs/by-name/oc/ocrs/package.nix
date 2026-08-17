{
  lib,
  fetchFromGitHub,
  rustPlatform,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "ocrs";
  version = "0.12.2";

  src = fetchFromGitHub {
    owner = "robertknight";
    repo = "ocrs";
    tag = "ocrs-v${finalAttrs.version}";
    hash = "sha256-OJnWFM6EfpcPI2QwdjiNqS1JzfwxvE4YhSyR0ZHpYg4=";
  };

  cargoHash = "sha256-3p9kFdzv1N+fyTavzu09pyarn5WtMu0IoWNzzm2IalU=";

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Library and tool for OCR, extracting text from images";
    homepage = "https://github.com/robertknight/ocrs";
    mainProgram = "ocrs";
    license = with lib.licenses; [
      asl20
      mit
    ];
    maintainers = with lib.maintainers; [
      ethancedwards8
    ];
  };
})
