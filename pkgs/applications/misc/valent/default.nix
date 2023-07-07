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
  version = "unstable-2023-06-11";

  src = fetchFromGitHub {
    owner = "andyholmes";
    repo = "valent";
    rev = "e6a121efa7eb7b432517d610de4deea6dfa876b0";
    fetchSubmodules = true;
    hash = "sha256-8X4Yu8VY5ehptJN1KtsCuoECtEZNLZMzOvU91j8UmDk=";
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
