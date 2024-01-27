{ lib
, stdenv
, fetchFromGitHub
, desktop-file-utils
, meson
, ninja
, pkg-config
, wrapGAppsHook4
, evolution-data-server-gtk4
, glib
, glib-networking
, gnutls
, gst_all_1
, json-glib
, libadwaita
, libpeas2
, libportal-gtk4
, pulseaudio
, sqlite
}:

stdenv.mkDerivation rec {
  pname = "valent";
  version = "unstable-2023-11-11";

  src = fetchFromGitHub {
    owner = "andyholmes";
    repo = "valent";
    rev = "51bca834b1c52a1cc49b79fe79d45dfcd9113c02";
    fetchSubmodules = true;
    hash = "sha256-jmhio/vS+w37IW81XgV4xfb/6ralMgAlwi3zigr4t20=";
  };

  nativeBuildInputs = [
    desktop-file-utils
    meson
    ninja
    pkg-config
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
    libpeas2
    libportal-gtk4
    pulseaudio
    sqlite
  ];

  mesonFlags = [
    "-Dplugin_bluez=true"
    # FIXME: libpeas2 (and libpeas) not compiled with -Dvapi=true
    "-Dvapi=false"
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
