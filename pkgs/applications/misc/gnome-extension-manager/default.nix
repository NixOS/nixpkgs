{ stdenv
, lib
, fetchFromGitHub
, wrapGAppsHook4
, libadwaita
, meson
, ninja
, gettext
, gtk4
, appstream-glib
, desktop-file-utils
, gobject-introspection
, blueprint-compiler
, pkg-config
, json-glib
, libsoup_3
, glib
, libbacktrace
, python3
, text-engine
}:

stdenv.mkDerivation rec {
  pname = "gnome-extension-manager";
  version = "0.4.2";

  src = fetchFromGitHub {
    owner = "mjakeman";
    repo = "extension-manager";
    rev = "v${version}";
    hash = "sha256-AQdYZsOaTk+EX1bi/kDI2GcVfu7ZKIyrFpNf/fRcJmo=";
  };

  nativeBuildInputs = [
    appstream-glib
    desktop-file-utils
    gettext
    glib
    gobject-introspection
    libadwaita
    meson
    ninja
    pkg-config
    python3
    wrapGAppsHook4
  ];

  buildInputs = [
    blueprint-compiler
    gtk4
    json-glib
    libsoup_3
    libbacktrace
    text-engine
  ];

  meta = with lib; {
    description = "Desktop app for managing GNOME shell extensions";
    homepage = "https://github.com/mjakeman/extension-manager";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ foo-dogsquared ];
  };
}
