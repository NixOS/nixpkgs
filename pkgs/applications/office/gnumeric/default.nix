{ stdenv, fetchurl, pkgconfig, intltool, perl, perlXMLParser
, goffice, gnome3, makeWrapper, gtk3
, python, pygobject3
}:

stdenv.mkDerivation rec {
  name = "gnumeric-1.12.26";

  src = fetchurl {
    url = "mirror://gnome/sources/gnumeric/1.12/${name}.tar.xz";
    sha256 = "48250718133e998f7b2e73f71be970542e46c9096afb936dbcb152cf5394ee14";
  };

  configureFlags = "--disable-component";

  # ToDo: optional libgda, introspection?
  buildInputs = [
    pkgconfig intltool perl perlXMLParser
    goffice gtk3 makeWrapper gnome3.defaultIconTheme
    python pygobject3
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
