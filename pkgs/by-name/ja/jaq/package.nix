{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "jaq";
  version = "2.3.0";

  src = fetchFromGitHub {
    owner = "01mf02";
    repo = "jaq";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ZVTDbJ5RPgQeB4ntnNQcbbWquPFL7q4WYyQ5ihCVB64=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-hEILrjIJK/8CrQv5QcHu+AtPV7KcPdmw6422MyNoPwo=";

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Jq clone focused on correctness, speed and simplicity";
    homepage = "https://github.com/01mf02/jaq";
    changelog = "https://github.com/01mf02/jaq/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    teams = [ lib.teams.ngi ];
    maintainers = with lib.maintainers; [
      figsoda
      siraben
    ];
    mainProgram = "jaq";
  };
})
