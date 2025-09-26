{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

buildNpmPackage rec {
  pname = "httpyac";
  version = "6.16.7";

  src = fetchFromGitHub {
    owner = "anweber";
    repo = "httpyac";
    tag = version;
    hash = "sha256-6qhKOb2AJrDhZLRU6vrDfuW9KED+5TLf4hHH/0iADeA=";
  };

  npmDepsHash = "sha256-X3Yz+W7lijOLP+tEuO0JOpeOMOGdUYN6OpxPYHwFQEo=";

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgramArg = "--version";
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
    maintainers = with lib.maintainers; [ ];
    platforms = lib.platforms.all;
  };
}
