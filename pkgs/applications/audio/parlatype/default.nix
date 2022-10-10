{ lib, stdenv, fetchFromGitHub, pkg-config, meson, gtk3, dbus, gst_all_1, ninja, gettext, appstream-glib, python3, desktop-file-utils, glib, gobject-introspection, gsettings-desktop-schemas, isocodes, itstool, libxml2, wrapGAppsHook, hicolor-icon-theme }:

stdenv.mkDerivation rec {
  pname = "parlatype";
  version = "3.1";

  src = fetchFromGitHub {
    owner  = "gkarsay";
    repo   = pname;
    rev    = "v${version}";
    sha256 = "1a4xlsbszb50vnz1g7kf7hl7aywp7s7xaravkcx13csn0a7l3x45";
  };

  nativeBuildInputs = [
    pkg-config
    meson
    ninja
    gettext
    appstream-glib
    python3
    desktop-file-utils
    gobject-introspection
    itstool
    libxml2
    wrapGAppsHook
  ];

  buildInputs = [
    gtk3
    dbus
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-plugins-ugly
    gst_all_1.gst-libav
    glib
    gsettings-desktop-schemas
    hicolor-icon-theme
    isocodes
  ];

  postPatch = ''
    patchShebangs data/meson_post_install.py
    patchShebangs libparlatype/tests/data/generate_config_data
  '';

  doCheck = false;

  meta = with lib; {
    description = "GNOME audio player for transcription";
    longDescription = ''
      Parlatype is a minimal audio player for manual speech transcription, written for the GNOME desktop environment.
      It plays audio sources to transcribe them in your favourite text application.
      It’s intended to be useful for journalists, students, scientists and whoever needs to transcribe audio files.
    '';
    homepage = "https://www.parlatype.org/";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ alexshpilkin melchips ];
    platforms = platforms.linux;
  };
}
