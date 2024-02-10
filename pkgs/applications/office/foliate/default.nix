{ stdenv
, lib
, fetchFromGitHub
, meson
, gettext
, glib
, gjs
, ninja
, gtk4
, webkitgtk_6_0
, gsettings-desktop-schemas
, wrapGAppsHook4
, desktop-file-utils
, gobject-introspection
, glib-networking
, pkg-config
, libadwaita
}:

stdenv.mkDerivation rec {
  pname = "foliate";
  version = "3.1.0";

  src = fetchFromGitHub {
    owner = "johnfactotum";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-6cymAqQxHHoTgzEyUKXC7zV/lUEJfIG+54+tLsc9iHo=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    desktop-file-utils
    gobject-introspection
    meson
    ninja
    pkg-config
    wrapGAppsHook4
  ];

  buildInputs = [
    gettext
    gjs
    glib
    glib-networking
    gsettings-desktop-schemas
    gtk4
    libadwaita
    webkitgtk_6_0
  ];

  meta = with lib; {
    description = "A simple and modern GTK eBook reader";
    homepage = "https://johnfactotum.github.io/foliate";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ onny ];
  };
}
