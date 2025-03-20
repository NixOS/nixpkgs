{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  darwin,
}:

rustPlatform.buildRustPackage rec {
  pname = "mqttui";
  version = "0.22.0";

  src = fetchFromGitHub {
    owner = "EdJoPaTo";
    repo = "mqttui";
    tag = "v${version}";
    hash = "sha256-q4C4YAs8Q1jHA5P2OApkFZnYM4/aZGxnE8Pd6Hmwd1I=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-pn4wmlMW8p6IAHrYjmvmZxNMjIJwJ2MYRsANz4D6xCU=";

  buildInputs = lib.optional stdenv.hostPlatform.isDarwin darwin.apple_sdk.frameworks.Security;

  meta = {
    description = "Terminal client for MQTT";
    homepage = "https://github.com/EdJoPaTo/mqttui";
    changelog = "https://github.com/EdJoPaTo/mqttui/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      fab
      sikmir
    ];
    mainProgram = "mqttui";
  };
}
