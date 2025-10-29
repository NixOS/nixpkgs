{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
  unstableGitUpdater,
}:
buildGoModule rec {
  pname = "chirpstack-fuota-server";
  version = "3.0.0-test.4-unstable-2025-08-26";

  src = fetchFromGitHub {
    owner = "chirpstack";
    repo = "chirpstack-fuota-server";
    rev = "0d3ce7d8d50ab8d8747d2099a2a607b0ec4e86cb";
    hash = "sha256-OprWgex8Yzx/vElL84NlnbFwayeXhQLNVl7koZUb3hU=";
  };

  vendorHash = "sha256-dTmHkauFelqMo5MpB/TyK5yVax5d4/+g9twjmsRG3e0=";

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version}"
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];

  doInstallCheck = true;
  versionCheckProgramArg = "version";
  checkFlags = [
    "-skip=TestStorage" # Depends on external database server
  ];

  passthru.updateScript = unstableGitUpdater {
    tagPrefix = "v";
  };

  meta = {
    description = "FUOTA server which can be used together with ChirpStack Application Server";
    homepage = "https://www.chirpstack.io/";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.stv0g ];
    mainProgram = "chirpstack-fuota-server";
  };
}
