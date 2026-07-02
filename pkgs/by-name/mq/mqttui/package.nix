{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "mqttui";
  version = "0.23.0";

  src = fetchFromGitHub {
    owner = "EdJoPaTo";
    repo = "mqttui";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Z9Xfg3y26e0sKhutm5Xvm8V6LYNJWvobjU5R6Inll0E=";
  };

  cargoHash = "sha256-Nyaiu9DEMJK8EHZQ0xPWPKgvD0yhlFhtdvQ4JjbKcvs=";

  meta = {
    description = "Terminal client for MQTT";
    homepage = "https://github.com/EdJoPaTo/mqttui";
    changelog = "https://github.com/EdJoPaTo/mqttui/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      fab
      sikmir
    ];
    mainProgram = "mqttui";
  };
})
