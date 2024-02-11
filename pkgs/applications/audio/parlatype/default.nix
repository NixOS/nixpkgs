{ lib
, stdenv
, fetchFromGitHub
, appstream-glib
, desktop-file-utils
, gettext
, glib
, gst_all_1
, gtk4
, hicolor-icon-theme
, isocodes
, itstool
, libxml2
, meson
, ninja
, pkg-config
, python3
, wrapGAppsHook
}:

stdenv.mkDerivation rec {
  pname = "parlatype";
  version = "4.0";

  src = fetchFromGitHub {
    owner = "gkarsay";
    repo = pname;
    rev = "v${version}";
    sha256 = "1iyjxss6sgc9gx6ij30zz97bl31qix8pxklzn4kknh1b0j7hhbwq";
  };

  nativeBuildInputs = [
    appstream-glib
    desktop-file-utils
    gettext
    itstool
    libxml2
    meson
    ninja
    pkg-config
    python3
    wrapGAppsHook
  ];

  buildInputs = [
    glib
    gst_all_1.gst-libav
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-ugly
    gst_all_1.gstreamer
    gtk4
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
      Parlatype is a minimal audio player for manual speech transcription,
      written for the GNOME desktop environment. It plays audio sources to
      transcribe them in your favourite text application. It’s intended to be
      useful for journalists, students, scientists and whoever needs to
      transcribe audio files.
    '';
    homepage = "https://www.parlatype.org/";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ alexshpilkin melchips ];
    platforms = platforms.linux;
  };
}
