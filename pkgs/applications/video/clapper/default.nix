{ config
, lib
, stdenv
, fetchFromGitHub
, glib
, gobject-introspection
, python3
, pkg-config
, ninja
, wayland
, wayland-protocols
, desktop-file-utils
, makeWrapper
, shared-mime-info
, wrapGAppsHook4
, meson
, gjs
, gtk4
, gst_all_1
, libadwaita
, appstream-glib
, libsoup
}:

stdenv.mkDerivation rec {
  pname = "clapper";
  version = "0.5.2";

  src = fetchFromGitHub {
    owner  = "Rafostar";
    repo   = pname;
    rev    = version;
    sha256 = "sha256-s+qdTq3/pHHstwr1W3Hs2Zje++iJFHM6hQTFoZD43bY=";
  };

  nativeBuildInputs = [
    appstream-glib
    desktop-file-utils # for update-desktop-database
    glib
    gobject-introspection
    meson
    ninja
    makeWrapper
    pkg-config
    python3
    shared-mime-info # for update-mime-database
    wrapGAppsHook4 # for gsettings
  ];

  buildInputs = [
    gjs
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-plugins-ugly
    gtk4
    libadwaita
    libsoup
    wayland
    wayland-protocols
  ];

  postPatch = ''
    patchShebangs build-aux/meson/postinstall.py
  '';

  postInstall = ''
    cp ${src}/data/icons/*.svg $out/share/icons/hicolor/scalable/apps/
    cp ${src}/data/icons/*.svg $out/share/icons/hicolor/symbolic/apps/
  '';

  meta = with lib; {
    description = "A GNOME media player built using GJS with GTK4 toolkit and powered by GStreamer with OpenGL rendering. ";
    longDescription = ''
      Clapper is a GNOME media player build using GJS with GTK4 toolkit.
      The media player is using GStreamer as a media backend and renders everything via OpenGL.
    '';
    homepage = "https://github.com/Rafostar/clapper";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ tomfitzhenry ];
    platforms = platforms.linux;
  };
}
