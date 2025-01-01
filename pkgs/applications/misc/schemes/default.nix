{ lib
, stdenv
, fetchFromGitLab
, appstream-glib
, desktop-file-utils
, glib
, gtk4
, gtksourceview5
, libadwaita
, libpanel
, meson
, ninja
, pkg-config
, wrapGAppsHook4
}:

stdenv.mkDerivation rec {
  pname = "schemes";
  version = "46.0";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "chergert";
    repo = "schemes";
    rev = version;
    hash = "sha256-m82jR958f1g/4gSJ4NbNa4fwxVseH399Z8JpWr7tLh8=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    wrapGAppsHook4
    appstream-glib
    desktop-file-utils
  ];

  buildInputs = [
    glib
    gtk4
    libadwaita
    gtksourceview5
    libpanel
  ];

  meta = with lib; {
    description = "Edit GtkSourceView style-schemes for an application or platform";
    mainProgram = "schemes";
    homepage = "https://gitlab.gnome.org/chergert/schemes";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ _0xMRTT ];
    platforms = platforms.linux;
  };
}
