{ stdenv, fetchurl
, bzip2, glib, goffice, gtk3, intltool, libglade, libgsf, libxml2
, pango, pkgconfig, scrollkeeper, zlib
}:

stdenv.mkDerivation rec {
  name = "gnumeric-1.12.0";

  src = fetchurl {
    url = "mirror://gnome/sources/gnumeric/1.12/${name}.tar.xz";
    sha256 = "037b53d909e5d1454b2afda8c4fb1e7838e260343e36d4e36245f4a5d0e04111";
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
