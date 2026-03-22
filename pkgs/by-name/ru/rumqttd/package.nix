{
  lib,
  fetchFromGitHub,
  rustPlatform,
  versionCheckHook,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "rumqttd";
  version = "0.20.0";

  src = fetchFromGitHub {
    owner = "bytebeamio";
    repo = "rumqtt";
    tag = "rumqttd-${finalAttrs.version}";
    hash = "sha256-WFhVSFAp5ZIqranLpU86L7keQaReEUXxxGhvikF+TBw=";
  };
  cargoHash = "sha256-UP1uhG+Ow/jN/B8i//vujP7vpoQ5PjYGCrXs0b1bym4=";

  buildAndTestSubdir = "rumqttd";

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = [ "--version" ];

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version-regex=^rumqttd\\-(.+)$" ];
  };

  meta = {
    description = "High performance MQTT broker";
    homepage = "https://rumqtt.bytebeam.io/";
    changelog = "https://github.com/bytebeamio/rumqtt/releases/tag/rumqttd-${finalAttrs.version}";
    mainProgram = "rumqttd";
    license = lib.licenses.asl20;
    platforms = with lib.platforms; linux ++ darwin;
    maintainers = with lib.maintainers; [
      griffi-gh
    ];
  };
})
