{
  lib,
  fetchFromGitHub,
  rustPlatform,
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

  cargoHash = "sha256-gk5nA6np7dK4+j26aySNWfMZ9t/+7nZRaPsnhlDEnes=";

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
