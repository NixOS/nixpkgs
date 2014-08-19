{ stdenv, fetchurl, pkgconfig, intltool, perl, perlXMLParser
, goffice, makeWrapper, gtk3, gnome_icon_theme
}:

stdenv.mkDerivation rec {
  name = "gnumeric-1.12.12";

  src = fetchurl {
    url = "mirror://gnome/sources/gnumeric/1.12/${name}.tar.xz";
    sha256 = "096i9x6b4i6x24vc4lsxx8fg2n2pjs2jb6x3bkg3ppa2c60w1jq0";
  };

  preConfigure = ''sed -i 's/\(SUBDIRS.*\) doc/\1/' Makefile.in''; # fails when installing docs

  configureFlags = "--disable-component";

  # ToDo: optional libgda, python, introspection?
  buildInputs = [
    pkgconfig intltool perl perlXMLParser
    goffice gtk3 makeWrapper
  ];

  preFixup = ''
    for f in "$out"/bin/gnumeric-*; do
      wrapProgram $f \
        --prefix XDG_DATA_DIRS : "$XDG_ICON_DIRS:$GSETTINGS_SCHEMAS_PATH"
    done
    rm $out/share/icons/hicolor/icon-theme.cache
  '';

  meta = with stdenv.lib; {
    description = "The GNOME Office Spreadsheet";
    license = stdenv.lib.licenses.gpl2Plus;
    homepage = http://projects.gnome.org/gnumeric/;
    platforms = platforms.linux;
    maintainers = [ maintainers.vcunat ];
  };
}
