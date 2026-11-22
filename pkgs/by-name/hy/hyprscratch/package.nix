{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "hyprscratch";
  version = "0.7.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "sashetophizika";
    repo = "hyprscratch";
    tag = "v${finalAttrs.version}";
    hash = "sha256-0zSlqkPXu+IBpS4bnkzwaieIzSYbIgpT0mtVwrsas9Y=";
  };

  cargoHash = "sha256-UImnXfkn9LBEywbm/sud1obXSn99HZmxNWBEYIqUhn0=";

  nativeBuildInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  checkFlags = [ "skip=scratchpad::tests::test_named_workspace" ];
  doInstallCheck = true;

  meta = {
    description = "Improved scratchpad functionality for Hyprland";
    homepage = "https://github.com/sashetophizika/hyprscratch";
    changelog = "https://github.com/sashetophizika/hyprscratch/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ pierreborine ];
    mainProgram = "hyprscratch";
  };
})
