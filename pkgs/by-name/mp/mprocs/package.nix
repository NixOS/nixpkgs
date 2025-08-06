{
  lib,
  fetchFromGitHub,
  rustPlatform,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "mprocs";
  version = "0.7.3";

  src = fetchFromGitHub {
    owner = "pvolok";
    repo = "mprocs";
    tag = "v${version}";
    hash = "sha256-/FuvejcZoaHzlYh4zYDVS1WimzNMNbRZyM39OBi02VA=";
  };

  cargoHash = "sha256-i9oQT2vpA5nAgQgVpxxfRPvCIb4w1emt1YsjMS6UPIk=";

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "TUI tool to run multiple commands in parallel and show the output of each command separately";
    homepage = "https://github.com/pvolok/mprocs";
    changelog = "https://github.com/pvolok/mprocs/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      GaetanLepage
      pyrox0
    ];
    platforms = lib.platforms.unix;
    mainProgram = "mprocs";
  };
}
