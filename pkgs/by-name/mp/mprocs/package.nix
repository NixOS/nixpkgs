{
  lib,
  fetchFromGitHub,
  rustPlatform,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "mprocs";
  version = "0.9.2";

  src = fetchFromGitHub {
    owner = "pvolok";
    repo = "mprocs";
    tag = "v${finalAttrs.version}";
    hash = "sha256-UZFFeaesT71UQHPjiG2w5O2Ulyt86OVuFw7i3A7b91I=";
  };

  cargoHash = "sha256-htgl0zh73oHXbc9E90xtb5jM8zhXvSJCE9DBhd1SH2E=";

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
