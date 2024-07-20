{ stdenv
, lib
, fetchFromGitHub
, meson
, ninja
, pkg-config
, wrapGAppsHook4
, glib
, glib-networking
, gnome-online-accounts
, gtk4
, libadwaita
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gnome-online-accounts-gtk";
  version = "3.50.3";

  src = fetchFromGitHub {
    owner = "xapp-project";
    repo = "gnome-online-accounts-gtk";
    rev = finalAttrs.version;
    hash = "sha256-peElSkGl2dYeJmMUeB+xDoOY3MhHs7IsIQYr0iJZP58=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    wrapGAppsHook4
  ];

  buildInputs = [
    glib
    glib-networking
    gnome-online-accounts
    gtk4
    libadwaita # for goa-backend
  ];

  meta = with lib; {
    description = "Online accounts configuration utility";
    homepage = "https://github.com/xapp-project/gnome-online-accounts-gtk";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = teams.cinnamon.members;
  };
})
