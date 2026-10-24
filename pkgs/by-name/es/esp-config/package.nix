{
  lib,
  rustPlatform,
  fetchFromGitHub,
  stdenv,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "esp-config";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "esp-rs";
    repo = "esp-hal";
    tag = "esp-config-v${finalAttrs.version}";
    hash = "sha256-3u4vAypbaH+5J80m8eIzSNYzsFkGcf2uRO2lNf88cq0=";
  };

  __structuredAttrs = true;

  cargoHash = "sha256-FsdwKCyB12+ApQtPl8gcSK8n4CRRTamE+CPgktDZ9pU=";
  cargoPatches = [ ./add-Cargo.lock.patch ];

  buildAndTestSubdir = "esp-config";
  cargoBuildFlags = [
    "--features=tui"
  ];

  meta = {
    description = "Configure projects using esp-hal and related packages";
    homepage = "https://github.com/esp-rs/esp-hal/tree/main/esp-config";
    changelog = "https://github.com/esp-rs/esp-hal/blob/esp-config-v${finalAttrs.version}/esp-config/CHANGELOG.md";
    mainProgram = "esp-config";
    license = with lib.licenses; [
      mit # or
      asl20
    ];
    maintainers = with lib.maintainers; [ Merded ];
  };
})
