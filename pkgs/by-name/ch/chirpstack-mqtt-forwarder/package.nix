{
  lib,
  stdenv,
  darwin,
  rustPlatform,
  fetchFromGitHub,
  gitUpdater,
  protobuf,
}:
rustPlatform.buildRustPackage rec {
  pname = "chirpstack-mqtt-forwarder";
  version = "4.2.3";

  src = fetchFromGitHub {
    owner = "chirpstack";
    repo = "chirpstack-mqtt-forwarder";
    rev = "v${version}";
    hash = "sha256-rzVrR4xWM2y2Y1/A3VEb7LGvyEhqhvz8zlsPHv3nRQU=";
  };

  cargoHash = "sha256-hhlRPbKCONe3m3K1XMXs8KoeQMIjqeQbGHWp9w/MXUI=";

  nativeBuildInputs = [ protobuf ];

  buildInputs = lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.CoreFoundation
    darwin.apple_sdk.frameworks.Security
  ];

  doCheck = false;

  passthru.updateScript = gitUpdater { rev-prefix = "v"; };

  meta = with lib; {
    description = "ChirpStack MQTT Forwarder is a forwarder which can be installed on the gateway to forward LoRa data over MQTT";
    homepage = "https://www.chirpstack.io/";
    license = licenses.mit;
    maintainers = with maintainers; [ stv0g ];
    mainProgram = "chirpstack-mqtt-forwarder";
  };
}
