{ stdenv, lib, fetchFromGitHub, wrapGAppsHook, makeFontsConf
, autoreconfHook, gtk-doc, intltool, libtool, pkg-config, yelp-tools, itstool
, gst_all_1
, glib, libgsf, libxml2
, clutter-gtk, gtk2
, orc, fluidsynth
}:

stdenv.mkDerivation {

  pname = "buzztrax";
  version = "unstable-2022-01-26";

  src = fetchFromGitHub {
    owner = "Buzztrax";
    repo = "buzztrax";
    rev = "833287c6a06bddc922cd346d6f0fcec7a882aee5";
    hash = "sha256-iI6m+zBWDDBjmeuU9Nm4aIbEKfaPe36APPktdjznQpU=";
  };

  postPatch = ''
    touch AUTHORS
  '';

  # 'g_memdup' is deprecated: Use 'g_memdup2' instead
  env.NIX_CFLAGS_COMPILE = "-Wno-error=deprecated-declarations";


  nativeBuildInputs = [
    autoreconfHook gtk-doc intltool libtool pkg-config
    wrapGAppsHook yelp-tools itstool
  ];

  buildInputs = [

    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    glib libgsf libxml2
    clutter-gtk gtk2

    ## Optional
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-plugins-ugly
    orc
    fluidsynth
  ];

  meta = with lib; {
    description = "Buzztrax is a modular music composer for Linux.";
    homepage = "https://www.buzztrax.org/";
    license = licenses.lgpl21Plus;
    maintainers = [ maintainers.bendlas ];
    platforms = platforms.unix;
  };

}
