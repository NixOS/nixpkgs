{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "basalt";
  version = "0.12.7";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "erikjuhani";
    repo = "basalt";
    tag = "basalt/v${finalAttrs.version}";
    hash = "sha256-vhOJJ1U53fdUZKeM4alkYJ1sDND4ojxBSqrvrxSjkc8=";
  };

  cargoHash = "sha256-wSlF7wbFsiqbud5cSUvfZypcgErktAJ86js0UpDJEgo=";

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "TUI Application to manage Obsidian notes directly from the terminal";
    homepage = "https://github.com/erikjuhani/basalt";
    changelog = "https://github.com/erikjuhani/basalt/blob/${finalAttrs.src.tag}/basalt/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ faukah ];
    mainProgram = "basalt";
  };
})
