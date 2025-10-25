{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "firm";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "42futures";
    repo = "firm";
    tag = finalAttrs.version;
    hash = "sha256-3YJZMhUTwJQIL2k1KfYYtcJhLuf2lFCqB1CF2bu0AFU=";
    fetchSubmodules = true;
  };

  cargoHash = "sha256-5Iika01kokoX/MyJ59WHcN90boHNFdAmmA54yL1wUKU=";

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Text-based work management system for technologists";
    homepage = "https://github.com/42futures/firm";
    changelog = "https://github.com/42futures/firm/blob/${finalAttrs.src.tag}/CHANGES.md";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ yiyu ];
    mainProgram = "firm";
  };
})
