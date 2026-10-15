{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "nomino";
  version = "1.6.4";

  src = fetchFromGitHub {
    owner = "yaa110";
    repo = "nomino";
    rev = finalAttrs.version;
    hash = "sha256-By7zVHtbrQU0+cSbxNNxCcmTCoFABsjOLk8TCX8iFWA=";
  };

  cargoHash = "sha256-daHhCr55RzIHooGXBK831SYD1b8NPEDD6mtDut6nuaQ=";

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Batch rename utility for developers";
    homepage = "https://github.com/yaa110/nomino";
    changelog = "https://github.com/yaa110/nomino/releases/tag/v${finalAttrs.version}";
    license = with lib.licenses; [
      mit # or
      asl20
    ];
    maintainers = [ lib.maintainers.progrm_jarvis ];
    mainProgram = "nomino";
  };
})
