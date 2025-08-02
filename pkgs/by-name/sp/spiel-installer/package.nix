{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  python3,
  wrapGAppsHook4,
  gobject-introspection,
  desktop-file-utils,
  glib,
  gtk4,
  libadwaita,
  flatpak,
  appstream,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "spiel-installer";
  version = "0-unstable-2024-07-25";

  pyproject = false;

  src = fetchFromGitHub {
    owner = "project-spiel";
    repo = "spiel-installer";
    rev = "f0ef013ee481a8ec148b265efe9c4da4a3004281";
    hash = "sha256-oCVHOl8HtFSWduQ95flYkvvFXFnwHvdmpAFbND54QUc=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    wrapGAppsHook4
    gobject-introspection # for setup hook
    desktop-file-utils
    glib # for glib-compile-schemas
    gtk4 # for gtk4-update-icon-cache
  ];

  buildInputs = [
    glib
    gtk4
    libadwaita
    flatpak
    appstream
  ];

  dependencies = [
    python3.pkgs.pygobject3
    python3.pkgs.langcodes
  ];

  # Prevent double wrapping.
  dontWrapGApps = true;

  preFixup = ''
    # Pass GApp environment to Python wrapper.
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  meta = {
    description = "App to make the installation of Spiel voices easier";
    homepage = "https://github.com/project-spiel/spiel-installer";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ jtojnar ];
    mainProgram = "spiel-installer";
    platforms = lib.platforms.all;
  };
}
