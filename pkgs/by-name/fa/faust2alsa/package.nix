{
  faust,
  alsa-lib,
  atk,
  cairo,
  fontconfig,
  freetype,
  gdk-pixbuf,
  glib,
  gtk2,
  pango,
}:

faust.wrapWithBuildEnv {

  baseName = "faust2alsa";

  propagatedBuildInputs = [
    alsa-lib
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
