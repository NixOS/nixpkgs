{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:
buildGoModule (finalAttrs: {
  pname = "geteduroam-cli";
  version = "0.12";

  src = fetchFromGitHub {
    owner = "geteduroam";
    repo = "linux-app";
    tag = finalAttrs.version;
    hash = "sha256-+3mluLby3R0xVU9fIG+1B1A4yM1IfyUvw4wclwnV5s8=";
  };

  vendorHash = "sha256-l9hge1TS+7ix9/6LKWq+lTMjNM4/Lnw8gNrWB6hWCTk=";

  subPackages = [
    "cmd/geteduroam-cli"
  ];

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgram = "${placeholder "out"}/bin/geteduroam-cli";
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "CLI client to configure eduroam";
    mainProgram = "geteduroam-cli";
    homepage = "https://github.com/geteduroam/linux-app";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ viperML ];
    platforms = lib.platforms.linux;
    changelog = "https://github.com/geteduroam/linux-app/releases/tag/${finalAttrs.version}";
  };
})
