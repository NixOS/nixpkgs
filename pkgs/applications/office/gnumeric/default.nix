{ stdenv, fetchurl, pkgconfig, intltool, perl, perlXMLParser
, goffice, gnome3, makeWrapper, gtk3, bison
, python, pygobject3
}:

stdenv.mkDerivation rec {
  name = "gnumeric-1.12.32";

  src = fetchurl {
    url = "mirror://gnome/sources/gnumeric/1.12/${name}.tar.xz";
    sha256 = "a07bc83e2adaeb94bfa2c737c9a19d90381a19cb203dd7c4d5f7d6cfdbee6de8";
  };

  configureFlags = "--disable-component";

  # ToDo: optional libgda, introspection?
  buildInputs = [
    pkgconfig intltool perl perlXMLParser bison
    goffice gtk3 makeWrapper gnome3.defaultIconTheme
    python pygobject3
  ];

  enableParallelBuilding = true;

  preFixup = ''
    for f in "$out"/bin/gnumeric-*; do
      wrapProgram $f \
        --prefix XDG_DATA_DIRS : "$XDG_ICON_DIRS:$GSETTINGS_SCHEMAS_PATH" \
        ${stdenv.lib.optionalString (!stdenv.isDarwin) "--prefix GIO_EXTRA_MODULES : '${gnome3.dconf}/lib/gio/modules'"}
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
