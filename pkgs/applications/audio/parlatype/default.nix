{
  lib,
  stdenv,
  fetchFromGitHub,
  appstream-glib,
  desktop-file-utils,
  gettext,
  glib,
  gst_all_1,
  gtk4,
  hicolor-icon-theme,
  isocodes,
  itstool,
  libadwaita,
  libxml2,
  meson,
  ninja,
  pkg-config,
  python3,
  wrapGAppsHook4,
}:

stdenv.mkDerivation rec {
  pname = "parlatype";
  version = "4.1";

  src = fetchFromGitHub {
    owner = "gkarsay";
    repo = pname;
    rev = "v${version}";
    sha256 = "0546rl5sm7xmgl54cqps3a7bhfs7xdvz98jgdcf4sgiz1k2vh9xq";
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
    wrapGAppsHook4
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
    libadwaita
  ];

  postPatch = ''
    substituteInPlace data/meson_post_install.py \
      --replace-fail 'gtk-update-icon-cache' 'gtk4-update-icon-cache'
    patchShebangs data/meson_post_install.py
    patchShebangs libparlatype/tests/data/generate_config_data
  '';

  doCheck = false;

  meta = with lib; {
    description = "GNOME audio player for transcription";
    mainProgram = "parlatype";
    longDescription = ''
      Parlatype is a minimal audio player for manual speech transcription,
      written for the GNOME desktop environment. It plays audio sources to
      transcribe them in your favourite text application. It’s intended to be
      useful for journalists, students, scientists and whoever needs to
      transcribe audio files.
    '';
    # maintainer lost control of parlatype.org
    homepage = "https://github.com/gkarsay/parlatype";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [
      alexshpilkin
      melchips
    ];
    platforms = platforms.linux;
  };
}
