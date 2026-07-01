{
  lib,
  fetchFromGitHub,
  rustPlatform,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "mprocs";
  version = "0.9.6";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "pvolok";
    repo = "mprocs";
    tag = "v${finalAttrs.version}";
    hash = "sha256-fh294Re4gEveWgX29m0SXdI8hwuiXuniTq7pVZ464ws=";
  };

  cargoHash = "sha256-Qp0o7ruXUZBCi7Abrj8V5MAY/qzo5Uf7pwIcFGwCfnw=";

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "TUI tool to run multiple commands in parallel and show the output of each command separately";
    homepage = "https://github.com/pvolok/mprocs";
    changelog = "https://github.com/pvolok/mprocs/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ GaetanLepage ];
    platforms = lib.platforms.unix;
    mainProgram = "mprocs";
  };
})
