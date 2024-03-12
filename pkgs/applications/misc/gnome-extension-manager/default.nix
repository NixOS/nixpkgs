{ stdenv
, lib
, fetchFromGitHub
, wrapGAppsHook4
, libadwaita
, meson
, ninja
, gettext
, gtk4
, appstream
, appstream-glib
, desktop-file-utils
, gobject-introspection
, blueprint-compiler
, pkg-config
, json-glib
, libsoup_3
, glib
, libbacktrace
, text-engine
}:

stdenv.mkDerivation rec {
  pname = "gnome-extension-manager";
  version = "0.4.3";

  src = fetchFromGitHub {
    owner = "mjakeman";
    repo = "extension-manager";
    rev = "v${version}";
    hash = "sha256-e+s8iIUvW9Rw0Wq4aIn3IzBLGTQC6o0TmNXd5gz892Y=";
  };

  nativeBuildInputs = [
    appstream
    appstream-glib
    desktop-file-utils
    gettext
    glib
    gobject-introspection
    meson
    ninja
    pkg-config
    wrapGAppsHook4
  ];

  buildInputs = [
    blueprint-compiler
    gtk4
    json-glib
    libadwaita
    libsoup_3
    libbacktrace
    text-engine
  ];

  mesonFlags = [
    (lib.mesonOption "package" "Nix")
    (lib.mesonOption "distributor" "nixpkgs")
  ];

  meta = with lib; {
    description = "Desktop app for managing GNOME shell extensions";
    homepage = "https://github.com/mjakeman/extension-manager";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    mainProgram = "extension-manager";
    maintainers = with maintainers; [ foo-dogsquared ];
  };
}
