{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

buildNpmPackage rec {
  pname = "httpyac";
  version = "6.16.6";

  src = fetchFromGitHub {
    owner = "anweber";
    repo = "httpyac";
    tag = version;
    hash = "sha256-JsrGoUZKo5/qjH+GKm5FBY19NE6KN7NhLpPvM8Cw97U=";
  };

  npmDepsHash = "sha256-08RJ1lLIaTXi3JHGIFR44GbEqOGez7+VFQGlejZqgAI=";

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgramArg = [ "--version" ];
  doInstallCheck = true;
  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    changelog = "https://github.com/anweber/httpyac/blob/${src.rev}/CHANGELOG.md";
    description = "Command Line Interface for *.http and *.rest files. Connect with http, gRPC, WebSocket and MQTT";
    homepage = "https://github.com/anweber/httpyac";
    license = lib.licenses.mit;
    mainProgram = "httpyac";
    maintainers = with lib.maintainers; [ drupol ];
    platforms = lib.platforms.all;
  };
}
