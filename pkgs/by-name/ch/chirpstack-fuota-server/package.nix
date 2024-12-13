{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:
buildGoModule rec {
  pname = "chirpstack-fuota-server";
  version = "3.0.0-test.4-unstable-2024-04-02";

  src = fetchFromGitHub {
    owner = "chirpstack";
    repo = "chirpstack-fuota-server";
    rev = "6e014688cb4b2a5dc658bf7876df69a1cf3e2176";
    hash = "sha256-ShpBUnDGaW8vbt5y1wZbedwFHPJaggPuij71l2p0a6o=";
  };

  vendorHash = "sha256-dTmHkauFelqMo5MpB/TyK5yVax5d4/+g9twjmsRG3e0=";

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version}"
  ];

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;
  versionCheckProgramArg = "version";

  checkFlags = [
    "-skip=TestStorage" # Depends on external database server
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "FUOTA server which can be used together with ChirpStack Application Server";
    homepage = "https://www.chirpstack.io/";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.stv0g ];
    mainProgram = "chirpstack-fuota-server";
  };
}
