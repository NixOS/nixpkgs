{
  lib,
  fetchFromGitHub,
  rustPlatform,
  nix-update-script,
  versionCheckHook,
}:

rustPlatform.buildRustPackage rec {
  pname = "basilk";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "gabalpha";
    repo = "basilk";
    tag = version;
    hash = "sha256-b77vVf+WbDNzKwGaMJvgMEMCC41h5TXmg45OM9g4v+4=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-Ak9ag/wInXtbnJRog4hHbyvMpDclWOSJ1gOIR+HwJ+8=";

  nativeInstallCheckInputs = [
    versionCheckHook
  ];

  versionCheckProgramArg = [ "--version" ];
  doInstallCheck = true;

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Terminal User Interface (TUI) to manage your tasks with minimal kanban logic";
    homepage = "https://github.com/gabalpha/basilk";
    changelog = "https://github.com/GabAlpha/basilk/releases/tag/${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ thtrf ];
    mainProgram = "basilk";
  };
}
