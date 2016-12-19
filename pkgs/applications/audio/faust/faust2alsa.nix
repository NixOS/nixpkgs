{ faust
, alsaLib
, atk
, cairo
, fontconfig
, freetype
, gdk_pixbuf
, glib
, gtk2
, pango
}:

faust.wrapWithBuildEnv {

  baseName = "faust2alsa";

  propagatedBuildInputs = [
    alsaLib
    atk
    cairo
    fontconfig
    freetype
    gdk_pixbuf
    glib
    gtk2
    pango
  ];

}
