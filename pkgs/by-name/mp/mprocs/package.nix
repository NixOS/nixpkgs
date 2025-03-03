{
  lib,
  fetchFromGitHub,
  rustPlatform,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "mprocs";
  version = "0.7.2";

  src = fetchFromGitHub {
    owner = "pvolok";
    repo = "mprocs";
    tag = "v${version}";
    hash = "sha256-bNA+P6Mnhxi6YH5gAUwvAPN7STUvwDnU/r/ZBYwzgrw=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-UnrwAff7Eer5Bpn2CTL2XOyM8J2Z2xofcH6d9eTr2yQ=";

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgramArg = [ "--version" ];
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
