{stdenv, fetchurl_gnome, gtk, pkgconfig, perl, perlXMLParser, libxml2, gettext
, python, libxml2Python, docbook5, docbook_xsl, libxslt, intltool, libart_lgpl
, withGNOME ? false, libgnomeui }:

stdenv.mkDerivation rec {
  name = src.pkgname;

  src = fetchurl_gnome {
    project = "dia";
    major = "0"; minor = "97"; patchlevel = "2"; extension = "xz";
    sha256 = "1qgawm7rrf4wd1yc0fp39ywv8gbz4ry1s16k00dzg5w6p67lfqd7";
  };

  buildInputs =
    [ gtk perlXMLParser libxml2 gettext python libxml2Python docbook5
      libxslt docbook_xsl libart_lgpl
    ] ++ stdenv.lib.optional withGNOME libgnomeui;

  buildNativeInputs = [ pkgconfig intltool perl ];

  configureFlags = stdenv.lib.optionalString withGNOME "--enable-gnome";

  meta = {
    description = "Gnome Diagram drawing software";
    homepage = http://live.gnome.org/Dia;
    maintainers = with stdenv.lib.maintainers; [raskin urkud];
    platforms = stdenv.lib.platforms.linux;
  };
}
