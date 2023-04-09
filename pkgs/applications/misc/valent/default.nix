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
  version = "unstable-2023-03-31";

  src = fetchFromGitHub {
    owner = "andyholmes";
    repo = "valent";
    rev = "bb9fc25a58eeb81abea2bb651accc9538a3a82fd";
    fetchSubmodules = true;
    sha256 = "sha256-3pEPE96gFjDGesFs/EZswuv6D3JQEpnAnlCw0IWYkR0=";
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
    maintainers = with maintainers; [ federicoschonborn ];
    platforms = platforms.linux;
  };
}
