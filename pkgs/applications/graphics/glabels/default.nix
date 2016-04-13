{ stdenv, fetchFromGitHub, autoconf, automake, barcode, gnome3
, gtk3, gtk_doc, libxml2, librsvg , libtool, libe-book
, intltool, itstool, makeWrapper, pkgconfig, which
}:

stdenv.mkDerivation rec {
  name = "glabels-${version}";
  version = "3.2.1";
  src = fetchFromGitHub {
    owner = "jimevins";
    repo = "glabels";
    rev = "glabels-3_2_1";
    sha256 = "1y6gz0v9si3cvdzhakbgkyc94fajg19rmykfgnc37alrc21vs9zg";
  };

  buildInputs = [
    autoconf automake barcode gtk3 gtk_doc gnome3.yelp_tools
    gnome3.gnome_common gnome3.gsettings_desktop_schemas
    intltool itstool libxml2 librsvg libe-book libtool
    makeWrapper pkgconfig 
  ];

  preFixup = ''
    rm "$out/share/icons/hicolor/icon-theme.cache"
    wrapProgram "$out/bin/glabels-3" \
      --prefix XDG_DATA_DIRS : "$GSETTINGS_SCHEMAS_PATH"
  '';

  preConfigure = "./autogen.sh";

  meta = {
    description = "Create labels and business cards";
    homepage = http://glabels.org/;
    license = stdenv.lib.licenses.gpl2;
    platforms = stdenv.lib.platforms.unix;
    maintainers = [ stdenv.lib.maintainers.nico202 ];
  };
}
