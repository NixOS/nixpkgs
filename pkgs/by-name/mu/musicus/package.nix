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
  sqlite,
  gst_all_1,
  dbus,
  openssl,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "musicus";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "johrpan";
    repo = "musicus";
    tag = "v${finalAttrs.version}";
    hash = "sha256-6+JcgseNgHN7q6v0+gcDmZKA7wr52QVG1lncxNynORU=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-PWqt5G+OjijyAoSj61iUjWBT6bV5d54okF/vm0+hWsA=";
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
    dbus
    openssl
    sqlite
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://github.com/johrpan/musicus";
    description = "Classical music player and organizer";
    mainProgram = "musicus";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ ];
  };
})
