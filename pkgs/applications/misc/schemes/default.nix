{ lib
, stdenv
, fetchFromGitLab
, appstream-glib
, desktop-file-utils
, glib
, gtk4
, gtksourceview5
, libadwaita
, libgee
, libpanel
, meson
, ninja
, pkg-config
, wrapGAppsHook4
}:

stdenv.mkDerivation rec {
  pname = "schemes";
  version = "0.2.0";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "chergert";
    repo = "schemes";
    rev = version;
    hash = "sha256-XUC24KzZSU4+F2JZMsydukvAwEGdMxCnkPG6QHnCw6w=";
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
    homepage = "https://gitlab.gnome.org/chergert/schemes";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ _0xMRTT ];
    platforms = platforms.linux;
  };
}
