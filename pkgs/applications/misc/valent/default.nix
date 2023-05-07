{ lib
, stdenv
, fetchFromGitHub
, desktop-file-utils
, meson
, ninja
, pkg-config
, vala
, wrapGAppsHook4
, evolution-data-server-gtk4
, glib
, glib-networking
, gnutls
, gst_all_1
, json-glib
, libadwaita
, libpeas
, libportal-gtk4
, pulseaudio
, sqlite
}:

stdenv.mkDerivation rec {
  pname = "valent";
  version = "unstable-2023-05-01";

  src = fetchFromGitHub {
    owner = "andyholmes";
    repo = "valent";
    rev = "74f5d9349a60f0d9fcf88cda01713980a221d639";
    fetchSubmodules = true;
    sha256 = "sha256-wqdujEKizrDFXtsjSTWpFgDL7MH3tsLTc7yd3LFgIQU=";
  };

  nativeBuildInputs = [
    desktop-file-utils
    meson
    ninja
    pkg-config
    vala
    wrapGAppsHook4
  ];

  buildInputs = [
    evolution-data-server-gtk4
    glib
    glib-networking
    gnutls
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    json-glib
    libadwaita
    libpeas
    libportal-gtk4
    pulseaudio
    sqlite
  ];

  mesonFlags = [
    "-Dplugin_bluez=true"
  ];

  meta = with lib; {
    description = "An implementation of the KDE Connect protocol, built on GNOME platform libraries";
    homepage = "https://github.com/andyholmes/valent/";
    changelog = "https://github.com/andyholmes/valent/blob/${src.rev}/CHANGELOG.md";
    license = with licenses; [ gpl3Plus cc0 ];
    maintainers = with maintainers; [ federicoschonborn aleksana ];
    platforms = platforms.linux;
  };
}
