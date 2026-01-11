{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "basalt";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "erikjuhani";
    repo = "basalt";
    tag = "basalt/v${finalAttrs.version}";
    hash = "sha256-r34MlNSLZAHqNWlFMGNxT6zTSX+IKKQmJ4klEB4kjek=";
  };

  cargoHash = "sha256-TpbJ1HCBocgLAXGb5dBbZNMlOYXR9IGBRtfShgwlMIo=";

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
