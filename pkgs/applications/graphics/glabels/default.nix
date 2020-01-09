{ stdenv, fetchurl, barcode, gnome3, autoreconfHook
, gtk3, gtk-doc, libxml2, librsvg , libtool, libe-book, gsettings-desktop-schemas
, intltool, itstool, makeWrapper, pkgconfig, yelp-tools
}:

stdenv.mkDerivation rec {
  pname = "glabels";
  version = "3.4.1";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "0f2rki8i27pkd9r0gz03cdl1g4vnmvp0j49nhxqn275vi8lmgr0q";
  };

  nativeBuildInputs = [ autoreconfHook pkgconfig makeWrapper intltool ];
  buildInputs = [
    barcode gtk3 gtk-doc yelp-tools
    gnome3.gnome-common gsettings-desktop-schemas
    itstool libxml2 librsvg libe-book libtool
  ];

  preFixup = ''
    wrapProgram "$out/bin/glabels-3" \
      --prefix XDG_DATA_DIRS : "$GSETTINGS_SCHEMAS_PATH"
  '';

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
      versionPolicy = "none";
    };
  };

  meta = with stdenv.lib; {
    description = "Create labels and business cards";
    homepage = https://glabels.org/;
    license = with licenses; [ gpl3Plus lgpl3Plus ];
    platforms = platforms.unix;
    maintainers = [ maintainers.nico202 ];
  };
}
