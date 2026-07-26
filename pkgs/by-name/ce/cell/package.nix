{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cell";
  version = "0.5.1";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "garritfra";
    repo = "cell";
    tag = "v${finalAttrs.version}";
    hash = "sha256-43E2EW3SS35VyJpOE7KdDz7XcOsn3V9aVglIW1vPgIE=";
  };

  cargoHash = "sha256-4qWI1dKv84Ga6A2ImkI3rRypqm+UkDNzD94Gxl43wj0=";

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Fast terminal spreadsheet editor with Vim keybindings";
    homepage = "https://github.com/garritfra/cell";
    changelog = "https://github.com/garritfra/cell/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ airrnot ];
    mainProgram = "cell";
  };
})
