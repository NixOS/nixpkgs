{stdenv, fetchurl, gtk, pkgconfig, glib, perl, perlXMLParser, libxml2, gettext, python, libxml2Python, docbook5, docbook_xsl, libxslt, intltool }:
stdenv.mkDerivation {
  name = "dia-0.97";

  src = fetchurl {
    url = mirror://gnome/sources/dia/0.97/dia-0.97.tar.bz2;
    sha256 = "0nngdjklap3x1b7cxnwawh29axbwk8siyq7w4iinsns3slmki0wh";
  };

  buildInputs = [gtk glib perl pkgconfig perlXMLParser libxml2 gettext python libxml2Python docbook5 libxslt docbook_xsl intltool];

  meta = {
    description = "Gnome Diagram drawing software.";
    homepage = http://live.gnome.org/Dia;
    maintainers = [stdenv.lib.maintainers.raskin];
    platforms = with stdenv.lib.platforms;
      linux;
  };
}
