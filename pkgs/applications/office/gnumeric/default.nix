{ stdenv, fetchurl
, bzip2, glib, goffice, gtk3, intltool, libglade, libgsf, libxml2
, pango, pkgconfig, scrollkeeper, zlib
}:

stdenv.mkDerivation {
  name = "gnumeric-1.11.3";
  
  src = fetchurl {
    url = mirror://gnome/sources/gnumeric/1.11/gnumeric-1.11.3.tar.xz;
    sha256 = "1hblcbba4qzlby094dih6ncclgf2n5ac59lqg9dykpz8ad3hxw72";
  };

  configureFlags = "--disable-component";

  buildInputs = [
    bzip2 glib goffice gtk3 intltool libglade libgsf libxml2
    pango pkgconfig scrollkeeper zlib
  ];

  meta = {
    description = "The GNOME Office Spreadsheet";
    license = "GPLv2+";
    homepage = http://projects.gnome.org/gnumeric/;
  };
}
