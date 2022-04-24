{ lib, stdenv, fetchFromGitHub, pkg-config, meson, gtk3, at-spi2-core, dbus, gst_all_1, sphinxbase, pocketsphinx, ninja, gettext, appstream-glib, python3, glib, gobject-introspection, gsettings-desktop-schemas, itstool, wrapGAppsHook, hicolor-icon-theme }:

stdenv.mkDerivation rec {
  pname = "parlatype";
  version = "2.1";

  src = fetchFromGitHub {
    owner  = "gkarsay";
    repo   = pname;
    rev    = "v${version}";
    sha256 = "1k53q0kbwpnbgyr0lmfzf5sm4f93d8nbjrzdz9pdhzpxgihndg25";
  };

  nativeBuildInputs = [
    pkg-config
    meson
    ninja
    gettext
    appstream-glib
    python3
    gobject-introspection
    itstool
    wrapGAppsHook
  ];

  buildInputs = [
    gtk3
    at-spi2-core
    dbus
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-plugins-ugly
    gst_all_1.gst-libav
    sphinxbase
    pocketsphinx
    glib
    gsettings-desktop-schemas
    hicolor-icon-theme
  ];

  postPatch = ''
    chmod +x data/meson_post_install.py
    patchShebangs data/meson_post_install.py
  '';

  doCheck = false;

  buildPhase = ''
    export GST_PLUGIN_SYSTEM_PATH_1_0="$out/lib/gstreamer-1.0/:$GST_PLUGIN_SYSTEM_PATH_1_0"
  '';

  meta = with lib; {
    description = "GNOME audio player for transcription";
    longDescription = ''
      Parlatype is a minimal audio player for manual speech transcription, written for the GNOME desktop environment.
      It plays audio sources to transcribe them in your favourite text application.
      It’s intended to be useful for journalists, students, scientists and whoever needs to transcribe audio files.
    '';
    homepage = "https://gkarsay.github.io/parlatype/";
    license = licenses.gpl3Plus;
    maintainers = [ maintainers.melchips ];
    platforms = platforms.linux;
  };
}
