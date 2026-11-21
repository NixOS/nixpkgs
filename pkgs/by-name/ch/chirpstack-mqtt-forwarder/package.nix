{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
  protobuf,
}:
rustPlatform.buildRustPackage rec {
  pname = "chirpstack-mqtt-forwarder";
  version = "4.7.0-test.2";

  src = fetchFromGitHub {
    owner = "chirpstack";
    repo = "chirpstack-mqtt-forwarder";
    rev = "v${version}";
    hash = "sha256-GOeyJdswMcyhuhvZdwBWtnp0mjr/dzLhgXSq6CVklwA=";
  };

  cargoHash = "sha256-wUyzT2Ub6CRngb0qycC2s0Rafor6n1/jj5PSmBXFL/U=";

  nativeBuildInputs = [ protobuf ];

  nativeInstallCheckInputs = [ versionCheckHook ];

  doInstallCheck = true;
  checkFlags = [
    "--skip=end_to_end" # Depends on internet connectivity
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Forwarder which can be installed on the gateway to forward LoRa data over MQTT";
    homepage = "https://www.chirpstack.io/";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.stv0g ];
    mainProgram = "chirpstack-mqtt-forwarder";
  };
}
