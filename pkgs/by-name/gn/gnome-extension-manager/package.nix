{
  lib,
  stdenv,
  fetchFromGitHub,

  appstream,
  appstream-glib,
  desktop-file-utils,
  gettext,
  glib,
  gobject-introspection,
  meson,
  ninja,
  pkg-config,
  wrapGAppsHook4,

  blueprint-compiler,
  gtk4,
  json-glib,
  libadwaita,
  libbacktrace,
  libsoup_3,
  libxml2,
}:

stdenv.mkDerivation rec {
  pname = "gnome-extension-manager";
  version = "0.6.3";

  src = fetchFromGitHub {
    owner = "mjakeman";
    repo = "extension-manager";
    rev = "v${version}";
    hash = "sha256-d9MmDDtxRDw+z5DqtnsKAWf5fw62CPkhrkGILiVjtzM=";
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
    libbacktrace
    libsoup_3
    libxml2
  ];

  mesonFlags = [
    (lib.mesonOption "package" "Nix")
    (lib.mesonOption "distributor" "nixpkgs")
  ];

  meta = {
    description = "Desktop app for managing GNOME shell extensions";
    homepage = "https://github.com/mjakeman/extension-manager";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    mainProgram = "extension-manager";
    maintainers = with lib.maintainers; [ foo-dogsquared ];
  };
}
