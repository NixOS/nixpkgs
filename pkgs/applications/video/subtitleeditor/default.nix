{ stdenv, fetchurl, fetchpatch, pkgconfig, intltool, file, desktop_file_utils,
  enchant, gnome3, gst_all_1, hicolor_icon_theme, libsigcxx, libxmlxx,
  xdg_utils, isocodes, wrapGAppsHook
}:

let
  ver_maj = "0.53";
  ver_min = "0";
in

stdenv.mkDerivation rec {
  name = "subtitle-editor-${ver_maj}.${ver_min}";

  src = fetchurl {
    url = "http://download.gna.org/subtitleeditor/${ver_maj}/subtitleeditor-${ver_maj}.${ver_min}.tar.gz";
    sha256 = "087rxignjawby4z3lwnh9m6pcjphl3a0jf7gfp83h92mzcq79b4g";
  };

  patches = [
    (fetchpatch {
      url = "https://sources.debian.net/data/main/s/subtitleeditor/0.53.0-2/debian/patches/03-fix-build-gstreamermm-1.8.0.patch";
      sha256 = "0di2i34id5dqnd3glibhifair1kdfnv8ay3k64lirad726ardw2c";
    })
  ];

  nativeBuildInputs =  [
    pkgconfig
    intltool
    file
    wrapGAppsHook
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

  enableParallelBuilding = true;

  # disable check because currently making check in po fails
  doCheck = false;

  hardeningDisable = [ "format" ];

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
    homepage = http://home.gna.org/subtitleeditor;
    license = stdenv.lib.licenses.gpl3Plus;
    maintainers = [ stdenv.lib.maintainers.plcplc ];
    platforms = stdenv.lib.platforms.linux;
  };
}
