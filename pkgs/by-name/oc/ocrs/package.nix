{
  lib,
  fetchFromGitHub,
  rustPlatform,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "ocrs";
  version = "0.12.0";

  src = fetchFromGitHub {
    owner = "robertknight";
    repo = "ocrs";
    tag = "ocrs-v${finalAttrs.version}";
    hash = "sha256-MHtMuUAFxfbbXI7jkS9mHbap9TbSmSilekFnSaI76Ac=";
  };

  cargoHash = "sha256-zYXhXGEWapAsEav3wpc17VWT8glFkys3BERCmhsUkZk=";

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
