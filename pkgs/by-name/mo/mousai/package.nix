{
  lib,
  stdenv,
  fetchFromGitHub,
  appstream-glib,
  cargo,
  dbus,
  desktop-file-utils,
  glib,
  glib-networking,
  gst_all_1,
  gtk4,
  libadwaita,
  libpulseaudio,
  libsoup_3,
  meson,
  ninja,
  nix-update-script,
  pkg-config,
  rustPlatform,
  rustc,
  wrapGAppsHook4,
}:

stdenv.mkDerivation rec {
  pname = "mousai";
  version = "0.7.10";

  src = fetchFromGitHub {
    owner = "SeaDve";
    repo = "Mousai";
    rev = "v${version}";
    hash = "sha256-xOP/lmJcZSdTeAMsV/vDpA2cDC7e8NJU6W1PImzLhZ4=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit pname version src;
    hash = "sha256-pVPS8+J9crn/Rt/PIW7yiVRmB1Y87vgNVojulU4tr7w=";
  };

  nativeBuildInputs = [
    appstream-glib
    desktop-file-utils
    meson
    ninja
    pkg-config
    wrapGAppsHook4
    rustPlatform.cargoSetupHook
    cargo
    rustc
  ];

  buildInputs = [
    dbus
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-bad
    glib
    glib-networking
    gtk4
    libadwaita
    libpulseaudio
    libsoup_3
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Identify any songs in seconds";
    mainProgram = "mousai";
    homepage = "https://github.com/SeaDve/Mousai";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ dotlambda ];
    teams = [ lib.teams.gnome-circle ];
    platforms = lib.platforms.linux;
  };
}
