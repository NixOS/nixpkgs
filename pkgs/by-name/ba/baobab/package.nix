{ stdenv
, lib
, gettext
, fetchurl
, vala
, desktop-file-utils
, meson
, ninja
, pkg-config
, gtk4
, libadwaita
, glib
, libxml2
, wrapGAppsHook4
, itstool
, gnome
}:

stdenv.mkDerivation rec {
  pname = "baobab";
  version = "47.0";

  src = fetchurl {
    url = "mirror://gnome/sources/baobab/${lib.versions.major version}/baobab-${version}.tar.xz";
    hash = "sha256-uI90+cBS08I4j3Bi0ijPXpJ1Raz3QIxWhB34DM0fnDc=";
  };

  nativeBuildInputs = [
    desktop-file-utils
    gettext
    glib
    itstool
    libxml2
    meson
    ninja
    pkg-config
    vala
    wrapGAppsHook4
  ];

  buildInputs = [
    gtk4
    libadwaita
    glib
  ];

  doCheck = true;

  passthru = {
    updateScript = gnome.updateScript {
      packageName = "baobab";
    };
  };

  meta = with lib; {
    description = "Graphical application to analyse disk usage in any GNOME environment";
    mainProgram = "baobab";
    homepage = "https://apps.gnome.org/Baobab/";
    license = licenses.gpl2Plus;
    maintainers = teams.gnome.members;
    platforms = platforms.unix;
  };
}
