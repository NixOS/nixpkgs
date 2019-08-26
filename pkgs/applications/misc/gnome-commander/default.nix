{ stdenv
, fetchurl
, substituteAll
, gtk2
, exiv2
, libgsf
, taglib
, libunique
, poppler
, gnome2
, gettext
, gexiv2
, glib
, gnome3
, itstool
, libxml2
, pkg-config
, shared-mime-info
, wrapGAppsHook
}:

stdenv.mkDerivation rec {
  pname = "gnome-commander";
  version = "1.10.3";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "7xMIUQWNYxlPeQv7uie2vitvKQbZI8zshHucxZUZOi4=";
  };

  patches = [
    (substituteAll {
      src = ./fix-paths.patch;
      schemadir = glib.makeSchemaPath "" "${pname}-${version}";
    })
  ];

  nativeBuildInputs = [
    pkg-config
    gettext
    glib # for glib-compile-schemas
    itstool
    libxml2 # for xmllint
    shared-mime-info
    wrapGAppsHook
  ];

  buildInputs = [
    glib
    gtk2
    exiv2
    libgsf
    taglib
    libunique
    poppler
    gnome2.gnome_vfs
  ];

  enableParallelBuilding = true;

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
    };
  };

  meta = with stdenv.lib; {
    description = "Powerful file manager for the GNOME desktop environment";
    homepage = https://gcmd.github.io/;
    license = licenses.gpl2Plus;
    maintainers = gnome3.maintainers;
    platforms = platforms.linux;
  };
}
