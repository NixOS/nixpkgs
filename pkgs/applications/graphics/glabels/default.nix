{ lib, stdenv, fetchurl, fetchpatch, barcode, gnome, autoreconfHook
, gtk3, gtk-doc, libxml2, librsvg , libtool, libe-book, gsettings-desktop-schemas
, intltool, itstool, makeWrapper, pkg-config, yelp-tools
}:

stdenv.mkDerivation rec {
  pname = "glabels";
  version = "3.4.1";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "0f2rki8i27pkd9r0gz03cdl1g4vnmvp0j49nhxqn275vi8lmgr0q";
  };

  patches = [
    # Pull patch pending upstream inclusion for -fno-common toolchain support:
    #   https://github.com/jimevins/glabels/pull/76
    (fetchpatch {
      name = "fno-common.patch";
      url = "https://github.com/jimevins/glabels/commit/f64e3f34e3631330fff2fb48ab271ff9c6160229.patch";
      sha256 = "13q6g4bxzvzwjnvzkvijds2b6yvc4xqbdwgqnwmj65ln6ngxz8sa";
    })
  ];

  nativeBuildInputs = [ autoreconfHook pkg-config makeWrapper intltool ];
  buildInputs = [
    barcode gtk3 gtk-doc yelp-tools
    gnome.gnome-common gsettings-desktop-schemas
    itstool libxml2 librsvg libe-book libtool
  ];

  preFixup = ''
    wrapProgram "$out/bin/glabels-3" \
      --prefix XDG_DATA_DIRS : "$GSETTINGS_SCHEMAS_PATH"
  '';

  passthru = {
    updateScript = gnome.updateScript {
      packageName = pname;
      versionPolicy = "none";
    };
  };

  meta = with lib; {
    description = "Create labels and business cards";
    homepage = "https://github.com/jimevins/glabels";
    license = with licenses; [ gpl3Plus lgpl3Plus ];
    platforms = platforms.unix;
    maintainers = [ maintainers.nico202 ];
  };
}
