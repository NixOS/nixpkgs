{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
}:
buildGoModule rec {
  pname = "chirpstack-gateway-bridge";
  version = "4.0.11";

  src = fetchFromGitHub {
    owner = "chirpstack";
    repo = "chirpstack-gateway-bridge";
    rev = "v${version}";
    hash = "sha256-nVrYyvoN6jayXAwivwxhijNeLEcGICTWJ4T9EBs5uaI=";
  };

  vendorHash = "sha256-PX5Jd8fUFEOOd38NNqbV15jbEIcDQRYGk0l1MhtLiTk=";

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
