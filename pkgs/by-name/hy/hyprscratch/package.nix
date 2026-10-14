{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "hyprscratch";
  version = "0.6.5";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "sashetophizika";
    repo = "hyprscratch";
    tag = "v${finalAttrs.version}";
    hash = "sha256-y3OnhY3GzHhxabxOcXWP5PJ/HZhaNOO0UgYM5Kzqkc8=";
  };

  cargoHash = "sha256-Sms+Nx2xQilN9IROVyuO1pl7fFGF8LYN6EhFcYQBLQs=";

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
