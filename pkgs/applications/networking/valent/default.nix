{ stdenv
, lib
, fetchFromGitHub
, meson
, pkg-config
, cmake
, ninja
, wrapGAppsHook4
, desktop-file-utils
, glib
, glib-networking
, gdk-pixbuf
, libadwaita
, sqlite
, gnutls
, libportal-gtk4
, evolution-data-server
, json-glib
, libpeas
, gst_all_1
, libsysprof-capture
, libpulseaudio
}:

stdenv.mkDerivation rec {
  pname = "valent";
  version = "unstable-2023-03-08";

  src = fetchFromGitHub {
    owner = "andyholmes";
    repo = pname;
    rev = "401fda881bc17d2424a621d41c9345f5e9e4f689";
    hash = "sha256-8TGl+U0tdR6jCTURATY86SxnjU6UiZUyMLrrmKPyvKw=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    meson
    pkg-config
    cmake
    ninja
    wrapGAppsHook4
    desktop-file-utils
  ];

  buildInputs = [
    glib
    glib-networking
    gdk-pixbuf
    libadwaita
    sqlite
    gnutls
    libportal-gtk4
    evolution-data-server
    json-glib
    libpeas
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-ugly
    gst_all_1.gstreamer
    libsysprof-capture
    libpulseaudio
  ];

  meta = with lib; {
    description = "Connect, control and sync devices";
    homepage = "https://github.com/andyholmes/valent";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ aleksana ];
    mainProgram = "valent";
  };
}
