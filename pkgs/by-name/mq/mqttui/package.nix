{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "mqttui";
  version = "0.24.0";

  src = fetchFromGitHub {
    owner = "EdJoPaTo";
    repo = "mqttui";
    tag = "v${finalAttrs.version}";
    hash = "sha256-NpWQGjIbm9HOyutcaojzwqta28pUIBlE0a/2ziun2pY=";
  };

  cargoHash = "sha256-wRkErkRm7cA/LWFhjQE4bwd4+mWANxZrZjj2CSfwshc=";

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
