{ stdenv, fetchurl, pkgconfig, autoconf, automake114x, intltool,
  desktop_file_utils, enchant, gnome3, gst_all_1, hicolor_icon_theme,
  libsigcxx, libxmlxx, xdg_utils, isocodes, wrapGAppsHook } :

let
  ver_maj = "0.52";
  ver_min = "1";
in

stdenv.mkDerivation rec {
  name = "subtitle-editor-${ver_maj}.${ver_min}";

  src = fetchurl {
    url = "http://download.gna.org/subtitleeditor/${ver_maj}/subtitleeditor-${ver_maj}.${ver_min}.tar.gz";
    sha256 = "1m8j2i27kjaycvp09b0knp9in61jd2dj852hrx5hvkrby70mygjv";
  };

  nativeBuildInputs =  [
    autoconf automake114x pkgconfig intltool wrapGAppsHook
  ];

  buildInputs =  [
    desktop_file_utils
    enchant
    gnome3.gtk
    gnome3.gtkmm
    gst_all_1.gstreamer
    gst_all_1.gstreamermm
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    hicolor_icon_theme
    libsigcxx
    libxmlxx
    xdg_utils
    isocodes
  ];

  NIX_CFLAGS_COMPILE = "-std=c++11 -DDEBUG";

  enableParallelBuilding = true;

  doCheck = true;

  hardeningDisable = [ "format" ];

  patches = [ ./subtitleeditor-0.52.1-build-fix.patch ];

  preConfigure = ''
    # ansi overrides -std, see src_configure
    sed 's/\(CXXFLAGS\) -ansi/\1/' -i configure.ac configure
  '';

  configureFlags = [ "--disable-debug" ];

  meta = {
    description = "GTK+3 application to edit video subtitles";
    longDescription = ''
      Subtitle Editor is a GTK+3 tool to edit subtitles for GNU/Linux/*BSD. It
      can be used for new subtitles or as a tool to transform, edit, correct
      and refine existing subtitle. This program also shows sound waves, which
      makes it easier to synchronise subtitles to voices.
      '';
    homepage = http://home.gna.org/subtitleeditor;
    license = stdenv.lib.licenses.gpl3Plus;
    maintainers = [ stdenv.lib.maintainers.plcplc ];
    platforms = stdenv.lib.platforms.linux;
  };
}
