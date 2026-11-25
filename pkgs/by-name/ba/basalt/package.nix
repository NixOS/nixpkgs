{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "basalt";
  version = "0.14.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "erikjuhani";
    repo = "basalt";
    tag = "basalt/v${finalAttrs.version}";
    hash = "sha256-befW+AvSuKyJb53iLqhpxEEb262O8E5epObFMWnx1GE=";
  };

  cargoHash = "sha256-l+5eMw79ZX2jca3YyQjsJzA1BYNUfFALgHbgXb63Ehk=";

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
