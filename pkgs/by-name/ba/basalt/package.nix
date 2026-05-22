{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "basalt";
  version = "0.12.4";

  src = fetchFromGitHub {
    owner = "erikjuhani";
    repo = "basalt";
    tag = "basalt/v${finalAttrs.version}";
    hash = "sha256-fijpPGPeF3f81WMWj1tIc0ht8hUIubAe19ja3iBNOh0=";
  };

  cargoHash = "sha256-jY3EDM+jYwCsMpd5cA5WKzmhdS4rVCLz3h5gfshzhOQ=";

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
