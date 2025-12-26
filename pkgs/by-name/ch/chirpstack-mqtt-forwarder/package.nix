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
  version = "4.4.1";

  src = fetchFromGitHub {
    owner = "chirpstack";
    repo = "chirpstack-mqtt-forwarder";
    rev = "v${version}";
    hash = "sha256-qkktkydg5Xe6q5IFalkxtGjO2zK9mZVMnKOBassiEtk=";
  };

  cargoHash = "sha256-rQPmFmra9Gd8XDP9HuTZZru780RmmqWEKX2iuuRkZQw=";

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
