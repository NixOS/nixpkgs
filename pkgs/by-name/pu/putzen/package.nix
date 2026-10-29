{
  lib,
  fetchFromGitHub,
  rustPlatform,
  nix-update-script,
  versionCheckHook,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  __structuredAttrs = true;

  pname = "putzen";
  version = "3.3.3";

  src = fetchFromGitHub {
    owner = "sassman";
    repo = "putzen-rs";
    tag = "v${finalAttrs.version}";
    hash = "sha256-lxMePdG8R8JHI1Rn7RkrSZK2Od/AGjsQNr9DxFbjR6U=";
  };

  cargoHash = "sha256-kp1p2JxcQnLfRA4utiKm7uWjZ1RbbV1uGDf6jO5GCQg=";

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Cleaning helper keeping your disk clean of build and dependency artifacts safely";
    homepage = "https://github.com/sassman/putzen-rs";
    changelog = "https://github.com/sassman/putzen-rs/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ adda ];
    mainProgram = "putzen";
  };
})
