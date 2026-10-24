{
  lib,
  stdenv,
  rustPlatform,
  fetchFromCodeberg,
  libcosmicAppHook,
  pkg-config,
  udev,
  libsodium,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cosmic-ext-fido2-manager";
  version = "0-unstable-2026-06-08";

  src = fetchFromCodeberg {
    owner = "Pandapip1";
    repo = "cosmic-ext-fido2-manager";
    rev = "19650d90adcece13c98a566c76880bdfdae6f5a5";
    hash = "sha256-PE4ukwBw8eIc2k8ci9TCojJRhiZfP18CzFaIrz1uiJY=";
  };

  cargoHash = "sha256-l2He1e/d9raLHRlEnZUbnclW1ivtuo2dfAmWQtWMCgY=";

  __structuredAttrs = true;
  strictDeps = true;
  separateDebugInfo = true;

  nativeBuildInputs = [
    libcosmicAppHook
    pkg-config
  ];
  buildInputs = [
    udev
    libsodium
  ];

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = {
    description = "Third-party COSMIC passkey manager";
    homepage = "https://codeberg.org/Pandapip1/cosmic-ext-fido2-manager";
    license = lib.licenses.gpl3Only;
    mainProgram = "cosmic-ext-fido2-manager";
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ pandapip1 ];
  };
})
