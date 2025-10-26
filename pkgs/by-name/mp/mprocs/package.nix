{
  lib,
  fetchFromGitHub,
  rustPlatform,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "mprocs";
  version = "0.8.3";

  src = fetchFromGitHub {
    owner = "pvolok";
    repo = "mprocs";
    tag = "v${finalAttrs.version}";
    hash = "sha256-8p8hPATAyc7ms2iXktrSEAmi6/ax85F5xwF6e7H4XRE=";
  };

  cargoHash = "sha256-wQNUHiOaq5fgZbwUEEco5MjX8xH2NoQnKCtM1cHchUQ=";

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
