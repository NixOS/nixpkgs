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
  version = "0.7.9";

  src = fetchFromGitHub {
    owner = "SeaDve";
    repo = "Mousai";
    rev = "v${version}";
    hash = "sha256-UhGqgVZ4K7+xKRGf7JYw4Mr+V+Cc3HjvGT8hDKaM6fo=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit pname version src;
    hash = "sha256-NYYVxVCONQoW+dcbwuJWzD2LAPhwOEQSgtfoY2iZi/c=";
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

  meta = with lib; {
    description = "Identify any songs in seconds";
    mainProgram = "mousai";
    homepage = "https://github.com/SeaDve/Mousai";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ dotlambda ];
    teams = [ teams.gnome-circle ];
    platforms = platforms.linux;
  };
}
