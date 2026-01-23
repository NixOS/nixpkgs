{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "basalt";
  version = "0.11.0";

  src = fetchFromGitHub {
    owner = "erikjuhani";
    repo = "basalt";
    tag = "basalt/v${finalAttrs.version}";
    hash = "sha256-+bkONCG4PSa266r0am2sjtz2WJXdhwijfJ8Uz3iEk68=";
  };

  cargoHash = "sha256-7jkeDZhGoufY1lHnhc2yKz2ulBf/nlV4ngY2XRSHF+4=";

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
