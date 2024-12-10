{
  lib,
  stdenv,
  darwin,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
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

  nativeInstallCheckInputs = [
    versionCheckHook
  ];

  # Skip tests depending on internet connectivity
  checkFlags = [ "--skip=end_to_end" ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Forwarder which can be installed on the gateway to forward LoRa data over MQTT";
    homepage = "https://www.chirpstack.io/";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.stv0g ];
    mainProgram = "chirpstack-mqtt-forwarder";
  };
}
