{ lib
, stdenv
, fetchFromGitHub
, meson
, ninja
, vala
, pkg-config
, blueprint-compiler
, desktop-file-utils
, wrapGAppsHook4
, gtk4
, libadwaita
, libsoup_3
, json-glib
, sqlite
, libgee
, libxml2
, gst_all_1
, webkitgtk_6_0
, glib-networking
}:

stdenv.mkDerivation rec {
  pname = "cassette";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "Rirusha";
    repo = "Cassette";
    rev = "ver-${version}";
    hash = "sha256-x9BRoLXrCO/7pI392MbO6m39rmpiOdCcp+pOLG6+k/s=";
  };

  nativeBuildInputs = [
    meson
    ninja
    vala
    pkg-config
    blueprint-compiler
    desktop-file-utils
    wrapGAppsHook4
  ];

  buildInputs = [
    gtk4
    libadwaita
    libsoup_3
    json-glib
    sqlite
    libgee
    libxml2
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-bad
    webkitgtk_6_0
    glib-networking
  ];

  meta = with lib; {
    description = "GTK4/Adwaita application that allows you to use Yandex Music service on Linux operating systems";
    homepage = "https://github.com/Rirusha/Cassette";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ averyanalex ];
    platforms = platforms.linux;
    mainProgram = "cassette";
  };
}
