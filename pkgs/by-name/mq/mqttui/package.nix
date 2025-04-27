{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  darwin,
}:

rustPlatform.buildRustPackage rec {
  pname = "mqttui";
  version = "0.22.1";

  src = fetchFromGitHub {
    owner = "EdJoPaTo";
    repo = "mqttui";
    tag = "v${version}";
    hash = "sha256-wKqIDKng4pfqDuYtqFRh3UIeZQ4QzzFlLkQn5MXcVlU=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-gk5nA6np7dK4+j26aySNWfMZ9t/+7nZRaPsnhlDEnes=";

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
