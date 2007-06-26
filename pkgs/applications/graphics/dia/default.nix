{stdenv, fetchurl, gtk, pkgconfig, glib, perl, perlXMLParser, libxml2, gettext, python, libxml2Python, docbook5, docbook_xsl, libxslt }:
stdenv.mkDerivation {
  name = "dia-0.96";

  src = fetchurl {
    url = http://ftp.gnome.org.nyud.net:8080/pub/gnome/sources/dia/0.96/dia-0.96.1.tar.bz2;
    md5 = "7b81b22baa2df55efe4845865dddc7b6";
  };

  buildInputs = [gtk glib perl pkgconfig perlXMLParser libxml2 gettext python libxml2Python docbook5 libxslt docbook_xsl];

  meta = {
    description = "Gnome Diagram drawing software.";
  };
}
