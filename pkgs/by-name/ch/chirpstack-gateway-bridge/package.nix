{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
}:
buildGoModule rec {
  pname = "chirpstack-gateway-bridge";
  version = "4.1.1";

  src = fetchFromGitHub {
    owner = "chirpstack";
    repo = "chirpstack-gateway-bridge";
    rev = "v${version}";
    hash = "sha256-zMD5vbdnfkGHhnw7fG88n6JY1RSrj2mMgMICR7n0cUo=";
  };

  vendorHash = "sha256-y1NYYyRS5L7QzV/bcm43EJ2OCHg+vPSTSwhHO0AwqD8=";

  ldflags = [
    "-s"
    "-w"
    "-X main.version=v${version}"
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];

  doInstallCheck = true;
  versionCheckProgramArg = "version";
  checkFlags = [
    "-skip=TestMQTTBackend" # Depends on external MQTT broker
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Gateway Bridge abstracts Packet Forwarder protocols into Protobuf or JSON over MQTT";
    homepage = "https://www.chirpstack.io/";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.stv0g ];
    mainProgram = "chirpstack-gateway-bridge";
  };
}
