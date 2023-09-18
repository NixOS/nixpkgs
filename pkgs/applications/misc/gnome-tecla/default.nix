{ stdenv
, lib
, fetchurl
, meson
, ninja
, pkg-config
, wrapGAppsHook4
, glib
, gtk4
, libadwaita
, libxkbcommon
, wayland
, gnome
}:

stdenv.mkDerivation rec {
  pname = "tecla";
  version = "45.0";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.major version}/${pname}-${version}.tar.xz";
    hash = "sha256-XAK7QBmxz/tWY9phB1A+/4U4Nqh4PdRwXdBKSfetwls=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    wrapGAppsHook4
  ];

  buildInputs = [
    glib
    gtk4
    libadwaita
    libxkbcommon
    wayland
  ];

  passthru = {
    updateScript = gnome.updateScript {
      attrPath = "gnome-tecla";
      packageName = "tecla";
    };
  };

  meta = with lib; {
    description = "Keyboard layout viewer";
    homepage = "https://gitlab.gnome.org/GNOME/tecla";
    license = licenses.gpl2Plus;
    maintainers = teams.gnome.members;
    platforms = platforms.unix;
    mainProgram = "tecla";
  };
}
