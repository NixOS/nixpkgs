{ stdenv, fetchurl, pkgconfig, intltool, perl, perlXMLParser
, goffice, gnome3, makeWrapper, gtk3
}:

stdenv.mkDerivation rec {
  name = "gnumeric-1.12.20";

  src = fetchurl {
    url = "mirror://gnome/sources/gnumeric/1.12/${name}.tar.xz";
    sha256 = "1k915ks55a32fpqrr0rx6j8ml9bw0a07f11350qc1bvkx53i2jad";
  };

  configureFlags = "--disable-component";

  # ToDo: optional libgda, python, introspection?
  buildInputs = [
    pkgconfig intltool perl perlXMLParser
    goffice gtk3 makeWrapper gnome3.defaultIconTheme
  ];

  enableParallelBuilding = true;

  preFixup = ''
    for f in "$out"/bin/gnumeric-*; do
      wrapProgram $f \
        --prefix XDG_DATA_DIRS : "$XDG_ICON_DIRS:$GSETTINGS_SCHEMAS_PATH" \
        --prefix GIO_EXTRA_MODULES : "${gnome3.dconf}/lib/gio/modules"
    done
  '';

  meta = with stdenv.lib; {
    description = "The GNOME Office Spreadsheet";
    license = stdenv.lib.licenses.gpl2Plus;
    homepage = http://projects.gnome.org/gnumeric/;
    platforms = platforms.linux;
    maintainers = [ maintainers.vcunat ];
  };
}
