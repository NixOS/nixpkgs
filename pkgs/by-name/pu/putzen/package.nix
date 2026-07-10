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
  version = "3.3.2";

  src = fetchFromGitHub {
    owner = "sassman";
    repo = "putzen-rs";
    tag = "v${finalAttrs.version}";
    hash = "sha256-OYWsylJo7odN0BCUbM2hrrsiRbvMIapYeSBwCfY0srk=";
  };

  cargoHash = "sha256-RqTBJCCJnvqujknJp7tK4oXMfBir9McfLaA5dtgYU90=";

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
