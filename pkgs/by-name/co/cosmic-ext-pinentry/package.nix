{
  lib,
  stdenv,
  rustPlatform,
  fetchFromCodeberg,
  libcosmicAppHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cosmic-ext-pinentry";
  version = "0-unstable-2026-06-28";

  src = fetchFromCodeberg {
    owner = "Pandapip1";
    repo = "cosmic-ext-pinentry";
    rev = "24ee24bee7870c4e820df95fc0ec26fcdbec1177";
    hash = "sha256-Klu1++j/YOzU1WO2MtAYe4JtnzV+aWRX5POvXK2JDE4=";
  };

  cargoHash = "sha256-JfjtAwzxUTO1HWyDv2U/wCvWTzkqcmHE7YuWeu8FAzQ=";

  __structuredAttrs = true;
  strictDeps = true;
  separateDebugInfo = true;

  nativeBuildInputs = [
    libcosmicAppHook
  ];

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = {
    description = "Third-party libcosmic-based pinentry program";
    homepage = "https://codeberg.org/Pandapip1/cosmic-ext-pinentry";
    license = lib.licenses.gpl3Only;
    mainProgram = "cosmic-ext-pinentry";
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ pandapip1 ];
  };
})
