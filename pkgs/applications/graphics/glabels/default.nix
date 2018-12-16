{ stdenv, fetchurl, barcode, gnome3, autoreconfHook
, gtk3, gtk-doc, libxml2, librsvg , libtool, libe-book
, intltool, itstool, makeWrapper, pkgconfig, hicolor-icon-theme
}:

stdenv.mkDerivation rec {
  name = "glabels-${version}";
  version = "3.4.1";

  src = fetchurl {
    url = "https://ftp.gnome.org/pub/GNOME/sources/glabels/3.4/glabels-3.4.1.tar.xz";
    sha256 = "0f2rki8i27pkd9r0gz03cdl1g4vnmvp0j49nhxqn275vi8lmgr0q";
  };

  nativeBuildInputs = [ autoreconfHook pkgconfig makeWrapper intltool ];
  buildInputs = [
    barcode gtk3 gtk-doc gnome3.yelp-tools
    gnome3.gnome-common gnome3.gsettings-desktop-schemas
    itstool libxml2 librsvg libe-book libtool
    hicolor-icon-theme
  ];

  preFixup = ''
    wrapProgram "$out/bin/glabels-3" \
      --prefix XDG_DATA_DIRS : "$GSETTINGS_SCHEMAS_PATH"
  '';

  meta = {
    description = "Create labels and business cards";
    homepage = http://glabels.org/;
    license = stdenv.lib.licenses.gpl2;
    platforms = stdenv.lib.platforms.unix;
    maintainers = [ stdenv.lib.maintainers.nico202 ];
  };
}
