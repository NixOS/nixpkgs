{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  blueprint-compiler,
  wrapGAppsHook4,
  desktop-file-utils,
  rustPlatform,
  cargo,
  rustc,
  pkg-config,
  glib,
  libadwaita,
  libxml2,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "iconic";
  version = "2025.3.2";

  src = fetchFromGitHub {
    owner = "youpie";
    repo = "Iconic";
    tag = "v${finalAttrs.version}";
    hash = "sha256-mj95GShV/PxFXweL14zTVANO10CGpXyktJjJGtD1XS8=";
  };

  postPatch = ''
    substituteInPlace src/windows/file_handling.rs \
      --replace-fail "/app" "$out"
    substituteInPlace src/windows/regeneration.rs \
      --replace-fail "/app" "$out"
    substituteInPlace src/config.rs \
      --replace-fail "/app" "$out"
    substituteInPlace src/window.rs \
      --replace-fail "create_dir" "create_dir_all"
  '';

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-/D4l85PO2h+172f8AgQFze665otIeouxEdVL56f+hoM=";
  };

  nativeBuildInputs = [
    meson
    ninja
    blueprint-compiler
    wrapGAppsHook4
    rustPlatform.cargoSetupHook
    cargo
    rustc
    desktop-file-utils
    pkg-config
  ];

  buildInputs = [
    glib
    libadwaita
    libxml2
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://github.com/youpie/Iconic";
    description = "Easilly add images on top of folders";
    mainProgram = "folder_icon";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ ];
  };
})
