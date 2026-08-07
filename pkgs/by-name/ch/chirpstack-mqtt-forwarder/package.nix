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
  version = "4.6.0";

  src = fetchFromGitHub {
    owner = "chirpstack";
    repo = "chirpstack-mqtt-forwarder";
    rev = "v${version}";
    hash = "sha256-frEwQrGfB1J7ZY5jSkmgAyyCJwWUyu29QuZqMWlOPSk=";
  };

  cargoHash = "sha256-5/8f5eSLfCu8fOfT+jTEfJj+fSB6rJt34C6eJwyFIfo=";

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
