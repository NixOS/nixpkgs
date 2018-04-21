{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig, intltool, file,
  desktop-file-utils, enchant, gnome3, gst_all_1, hicolor-icon-theme,
  libsigcxx, libxmlxx, xdg_utils, isocodes, wrapGAppsHook
}:

let
  version = "0.54.0";
in

stdenv.mkDerivation rec {
  name = "subtitleeditor-${version}";

  src = fetchFromGitHub {
    owner = "kitone";
    repo = "subtitleeditor";
    rev = version;
    sha256 = "0vxcscc9m6gymgj173ahk2g9hlk9588z5fdaavmkpyriqdlhwm11";
  };

  nativeBuildInputs =  [
    autoreconfHook
    pkgconfig
    intltool
    file
    wrapGAppsHook
  ];

  buildInputs =  [
    desktop-file-utils
    enchant
    gnome3.gtk
    gnome3.gtkmm
    gst_all_1.gstreamer
    gst_all_1.gstreamermm
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    hicolor-icon-theme
    libsigcxx
    libxmlxx
    xdg_utils
    isocodes
  ];

  enableParallelBuilding = true;

  preConfigure = "substituteInPlace ./configure --replace /usr/bin/file ${file}/bin/file";

  configureFlags = [ "--disable-debug" ];

  meta = {
    description = "GTK+3 application to edit video subtitles";
    longDescription = ''
      Subtitle Editor is a GTK+3 tool to edit subtitles for GNU/Linux/*BSD. It
      can be used for new subtitles or as a tool to transform, edit, correct
      and refine existing subtitle. This program also shows sound waves, which
      makes it easier to synchronise subtitles to voices.
      '';
    homepage = http://kitone.github.io/subtitleeditor/;
    license = stdenv.lib.licenses.gpl3Plus;
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.plcplc ];
  };
}
