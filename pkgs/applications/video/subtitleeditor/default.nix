{ lib, stdenv, fetchFromGitHub, autoreconfHook, pkg-config, intltool, file,
  desktop-file-utils, enchant, gtk3, gtkmm3, gst_all_1, hicolor-icon-theme,
  libsigcxx, libxmlxx, xdg-utils, isocodes, wrapGAppsHook
}:

stdenv.mkDerivation rec {
  pname = "subtitleeditor";
  version = "unstable-2019-11-30";

  src = fetchFromGitHub {
    owner = "kitone";
    repo = "subtitleeditor";
    rev = "4c215f4cff4483c44361a2f1d45efc4c6670787f";
    sha256 = "sha256-1Q1nd3GJ6iDGQv4SM2S1ehVW6kPdbqTn8KTtTb0obiQ=";
  };

  nativeBuildInputs =  [
    autoreconfHook
    pkg-config
    intltool
    file
    wrapGAppsHook
  ];

  buildInputs =  [
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
    homepage = "http://kitone.github.io/subtitleeditor/";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.plcplc ];
    mainProgram = "subtitleeditor";
  };
}
