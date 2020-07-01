{ faust
, alsaLib
, atk
, cairo
, fontconfig
, freetype
, gdk-pixbuf
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
    gdk-pixbuf
    glib
    gtk2
    pango
  ];

}
