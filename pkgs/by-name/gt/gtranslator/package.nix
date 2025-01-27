{
  stdenv,
  lib,
  fetchurl,
  meson,
  ninja,
  pkg-config,
  itstool,
  gettext,
  desktop-file-utils,
  wrapGAppsHook4,
  libxml2,
  libadwaita,
  libgda6,
  libsoup_3,
  libspelling,
  json-glib,
  glib,
  gtk4,
  gtksourceview5,
  gnome,
  gsettings-desktop-schemas,
}:

stdenv.mkDerivation rec {
  pname = "gtranslator";
  version = "47.1";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.major version}/${pname}-${version}.tar.xz";
    hash = "sha256-yRwCZLmpnjCR75EfcxqP9tCahKK8115WUZcdprvqYiI=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    itstool
    gettext
    desktop-file-utils
    wrapGAppsHook4
  ];

  buildInputs = [
    libxml2
    glib
    gtk4
    gtksourceview5
    libadwaita
    libgda6
    libsoup_3
    libspelling
    json-glib
    gettext
    gsettings-desktop-schemas
  ];

  passthru = {
    updateScript = gnome.updateScript {
      packageName = pname;
    };
  };

  meta = with lib; {
    description = "GNOME translation making program";
    mainProgram = "gtranslator";
    homepage = "https://gitlab.gnome.org/GNOME/gtranslator";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ bobby285271 ];
    platforms = platforms.linux;
  };
}
