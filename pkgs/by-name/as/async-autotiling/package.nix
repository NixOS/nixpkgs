{
  lib,
  fetchFromGitHub,
  rustPlatform,
  nix-update-script,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "async-autotiling";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "Ruixi-rebirth";
    repo = "async-autotiling";
    tag = "v${finalAttrs.version}";
    hash = "sha256-iBV1IA/UE96RTfekWtfpMTVUGQlCDMqzpIGTpGEoJ+8=";
  };

  cargoHash = "sha256-0kNjcM/dnPFvJdaIipTzeSICGMu8RdmfIP1g4YCAyZQ=";

  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Automatically switch between horizontal/vertical split layout for sway(and possibly i3)";
    homepage = "https://github.com/Ruixi-rebirth/async-autotiling";
    changelog = "https://github.com/Ruixi-rebirth/async-autotiling/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ Ruixi-rebirth ];
    mainProgram = "async-autotiling";
  };
})
