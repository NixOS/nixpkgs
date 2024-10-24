{ stdenv
, lib
, fetchurl
, flex
, itstool
, pkg-config
, libxslt
, wrapGAppsHook
, exiv2
, glib
, gtk2
, gvfs
, libgsf
, libunique
, poppler
, taglib
}:

stdenv.mkDerivation rec {
  pname = "gnome-commander";
  version = "1.14.3";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "sha256-eNjc5w+5IrKQnPdneDBTsIESE6TWpJs4dVEM86hO/Xs=";
  };

  nativeBuildInputs = [
    flex
    itstool
    pkg-config
    libxslt
    (wrapGAppsHook.override { gtk3 = gtk2; })
  ];

  buildInputs = [
    exiv2
    glib
    gtk2
    libgsf
    libunique
    poppler
    taglib
  ];

  patches = [ ./gsettings.patch ];

  postPatch = ''
    substituteInPlace data/org.gnome.${pname}.gschema.xml \
      --replace /usr/local/share/pixmaps/${pname}/mime-icons "$out"/share/pixmaps/${pname}/mime-icons
  '';

  postInstall = ''
    substituteInPlace "$out"/share/applications/org.gnome.${pname}.desktop \
      --replace Exec=${pname} Exec="$out"/bin/${pname}

    mkdir -p -- "$out"/share/icons/hicolor/scalable/apps
    ln -s -- "$out"/share/pixmaps/${pname}.svg "$out"/share/icons/hicolor/scalable/apps/${pname}.svg
  '';

  meta = with lib; {
    homepage = "https://gcmd.github.io/";
    description = "A powerful file manager for the GNOME desktop environment";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ twz123 ];
  };
}
