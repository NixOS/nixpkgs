{ stdenv, fetchurl, barcode, gnome3, autoreconfHook
, gtk3, gtk-doc, libxml2, librsvg , libtool, libe-book
, intltool, itstool, makeWrapper, pkgconfig, which
}:

stdenv.mkDerivation rec {
  name = "glabels-${version}";
  version = "3.4.0";

  src = fetchurl {
    url = "http://ftp.gnome.org/pub/GNOME/sources/glabels/3.4/glabels-3.4.0.tar.xz";
    sha256 = "04345crf5yrhq6rlrymz630rxnm8yw41vx04hb6xn2nkjn9hf3nl";
  };

  nativeBuildInputs = [ autoreconfHook pkgconfig makeWrapper intltool ];
  buildInputs = [
    barcode gtk3 gtk-doc gnome3.yelp-tools
    gnome3.gnome-common gnome3.gsettings-desktop-schemas
    itstool libxml2 librsvg libe-book libtool
    
  ];

  preFixup = ''
    rm "$out/share/icons/hicolor/icon-theme.cache"
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
