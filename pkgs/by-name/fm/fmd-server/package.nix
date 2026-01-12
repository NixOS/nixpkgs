{
  lib,
  buildGoModule,
  fetchFromGitLab,
  nix-update-script,
  versionCheckHook,
}:
let
  version = "0.13.0";
in
buildGoModule {
  pname = "fmd-server";
  inherit version;
  src = fetchFromGitLab {
    owner = "fmd-foss";
    repo = "fmd-server";
    tag = "v${version}";
    hash = "sha256-pIVsdoen45YWG/V8qW/DE/yet4o+8MqpVHgHh70Fty8=";
  };

  vendorHash = "sha256-d8QP6k7vEX0jBcpIMZymgOFYyKqGhND4Xa+mANg172s=";

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "version";

  doInstallCheck = true;
  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Server to communicate with the FindMyDevice app and save the latest (encrypted) location";
    homepage = "https://fmd-foss.org/";
    downloadPage = "https://gitlab.com/fmd-foss/fmd-server";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ j0hax ];
    teams = [ lib.teams.ngi ];
    mainProgram = "fmd-server";
  };
}
