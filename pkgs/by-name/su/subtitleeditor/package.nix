{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  intltool,
  file,
  desktop-file-utils,
  enchant,
  gtk3,
  gtkmm3,
  gst_all_1,
  hicolor-icon-theme,
  libsigcxx,
  libxmlxx,
  xdg-utils,
  isocodes,
  wrapGAppsHook3,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "subtitleeditor";
  version = "0.55.0";

  src = fetchFromGitHub {
    owner = "subtitleeditor";
    repo = "subtitleeditor";
    tag = finalAttrs.version;
    hash = "sha256-jhKewfhJ97zxUPp1P2twmgNkMQa/hi2ZZZ8mOFcCOlQ=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    intltool
    file
    wrapGAppsHook3
  ];

  buildInputs = [
    desktop-file-utils
    enchant
    gtk3
    gtkmm3
    gst_all_1.gstreamer
    gst_all_1.gstreamermm
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-plugins-ugly
    gst_all_1.gst-libav
    hicolor-icon-theme
    libsigcxx
    libxmlxx
    xdg-utils
    isocodes
  ];

  enableParallelBuilding = true;

  preConfigure = "substituteInPlace ./configure --replace /usr/bin/file ${file}/bin/file";

  configureFlags = [ "--disable-debug" ];

  meta = {
    description = "GTK 3 application to edit video subtitles";
    longDescription = ''
      Subtitle Editor is a GTK 3 tool to edit subtitles for GNU/Linux/*BSD. It
      can be used for new subtitles or as a tool to transform, edit, correct
      and refine existing subtitle. This program also shows sound waves, which
      makes it easier to synchronise subtitles to voices.
    '';
    homepage = "https://subtitleeditor.github.io/subtitleeditor/";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.plcplc ];
    mainProgram = "subtitleeditor";
  };
})
