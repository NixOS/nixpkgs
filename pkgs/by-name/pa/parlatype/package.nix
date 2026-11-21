{
  lib,
  stdenv,
  fetchFromGitHub,
  appstream-glib,
  desktop-file-utils,
  gettext,
  glib,
  gobject-introspection,
  gstreamer,
  gst-plugins-ugly,
  gst-plugins-good,
  gst-plugins-base,
  gst-plugins-bad,
  gst-libav,
  gtk4,
  hicolor-icon-theme,
  isocodes,
  itstool,
  libadwaita,
  libxml2,
  meson,
  ninja,
  pkg-config,
  pocketsphinx,
  python3,
  wrapGAppsHook4,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "parlatype";
  version = "4.3";

  src = fetchFromGitHub {
    owner = "gkarsay";
    repo = "parlatype";
    tag = "v${finalAttrs.version}";
    sha256 = "1kjsbwr08k1kzaan555zjk37r3l5qhpgrvjb1p57dnygk2g3hsm2";
  };

  nativeBuildInputs = [
    appstream-glib
    desktop-file-utils
    gettext
    gobject-introspection
    itstool
    libxml2
    meson
    ninja
    pkg-config
    python3
    wrapGAppsHook4
  ];

  buildInputs = [
    glib
    gst-libav
    gst-plugins-bad
    gst-plugins-base
    gst-plugins-good
    gst-plugins-ugly
    gstreamer
    gtk4
    hicolor-icon-theme
    isocodes
    libadwaita
    pocketsphinx
  ];

  postPatch = ''
    patchShebangs libparlatype/tests/data/generate_config_data
  '';

  mesonFlags = [
    "-Dgir=true"
    "-Dpocketsphinx=true"
  ];

  doCheck = false;

  meta = {
    description = "GNOME audio player for transcription";
    mainProgram = "parlatype";
    longDescription = ''
      Parlatype is a minimal audio player for manual speech transcription,
      written for the GNOME desktop environment. It plays audio sources to
      transcribe them in your favourite text application. It’s intended to be
      useful for journalists, students, scientists and whoever needs to
      transcribe audio files.
    '';
    homepage = "https://www.parlatype.xyz/";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [
      alexshpilkin
      melchips
    ];
    platforms = lib.platforms.linux;
  };
})
