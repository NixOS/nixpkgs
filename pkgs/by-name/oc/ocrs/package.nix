{
  lib,
  fetchFromGitHub,
  rustPlatform,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "ocrs";
  version = "0.14.0";

  src = fetchFromGitHub {
    owner = "robertknight";
    repo = "ocrs";
    tag = "ocrs-v${finalAttrs.version}";
    hash = "sha256-ZThOqEyuCH+E2U+2OOOC2Ib2jQK7wgIOFnqN/cpcQ/U=";
  };

  cargoHash = "sha256-q0FRXAMpvqYrR3JDYgH/Gwcr2osz4SxRSWRUP5tLlp0=";

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
