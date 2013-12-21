{ stdenv, fetchurl
, bzip2, glib, goffice, gtk3, intltool, libglade, libgsf, libxml2
, pango, pkgconfig, scrollkeeper, zlib
}:

stdenv.mkDerivation rec {
  name = "gnumeric-1.12.9";

  src = fetchurl {
    url = "mirror://gnome/sources/gnumeric/1.12/${name}.tar.xz";
    sha256 = "1rv2ifw6rp0iza4fkf3bffvdkyi77dwvzdnvcbpqcyn2kxfsvlsc";
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
