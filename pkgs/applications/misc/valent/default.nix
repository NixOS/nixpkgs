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
  version = "unstable-2023-07-31";

  src = fetchFromGitHub {
    owner = "andyholmes";
    repo = "valent";
    rev = "698f39b496957d50c68437f16e74a7ac41eb5147";
    fetchSubmodules = true;
    hash = "sha256-AdW6oMRVIgat8XlH342PEwe6BfkzKVLSadGOTLGwzwo=";
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
