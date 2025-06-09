{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "jaq";
  version = "2.2.0";

  src = fetchFromGitHub {
    owner = "01mf02";
    repo = "jaq";
    tag = "v${version}";
    hash = "sha256-mVC2aggfcEpCtriuz/s4JL8mYkrlyAQLnaN5vyfcW3s=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-ZZLp3Vwq013MPxKy9gTZ1yMi2O0QcDPgFw5YnrYt90I=";

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Jq clone focused on correctness, speed and simplicity";
    homepage = "https://github.com/01mf02/jaq";
    changelog = "https://github.com/01mf02/jaq/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      figsoda
      siraben
    ];
    mainProgram = "jaq";
  };
}
