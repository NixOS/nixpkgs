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
  version = "4.3.1";

  src = fetchFromGitHub {
    owner = "chirpstack";
    repo = "chirpstack-mqtt-forwarder";
    rev = "v${version}";
    hash = "sha256-jbu8O1Wag6KpN49VyXsYO8os95ctZjzuxKXoDMLyiKU=";
  };

  cargoHash = "sha256-1tAZjsjoVKUkrF0WAqxs9d+1w8/AqFGDfpFGAHvf+D0=";

  nativeBuildInputs = [ protobuf ];

  buildInputs = lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.CoreFoundation
    darwin.apple_sdk.frameworks.Security
  ];

  doCheck = false;

  passthru.updateScript = gitUpdater { rev-prefix = "v"; };

  meta = {
    description = "ChirpStack MQTT Forwarder is a forwarder which can be installed on the gateway to forward LoRa data over MQTT";
    homepage = "https://www.chirpstack.io/";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.stv0g ];
    mainProgram = "chirpstack-mqtt-forwarder";
  };
}
