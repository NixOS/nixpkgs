{
  lib,
  fetchFromGitHub,
  rustPlatform,
  versionCheckHook,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "rumqttd";
  version = "0.19.0";

  src = fetchFromGitHub {
    owner = "bytebeamio";
    repo = "rumqtt";
    tag = "rumqttd-${finalAttrs.version}";
    hash = "sha256-3rDnJ1VsyGBDhjOq0Rd55WI1EbIo+17tcFZCoeJB3Kc=";
  };

  cargoPatches = [
    ./cargo-fix-time.patch
  ];
  cargoHash = "sha256-E9nOjw/5s8hX9NUUZBXY8qLsiOUnnP60jpaCekwsoGc=";

  buildAndTestSubdir = "rumqttd";

  doInstallCheck = true;
  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgramArg = [ "--version" ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "High performance MQTT broker";
    homepage = "https://rumqtt.bytebeam.io/";
    changelog = "https://github.com/bytebeamio/rumqtt/releases/tag/rumqttd-${finalAttrs.version}";
    mainProgram = "rumqttd";
    license = lib.licenses.asl20;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ griffi-gh ];
  };
})
