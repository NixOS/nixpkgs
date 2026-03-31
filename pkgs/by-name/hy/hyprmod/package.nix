{
  lib,
  fetchFromGitHub,
  glib,
  gnome-desktop,
  gobject-introspection,
  gtk4,
  libadwaita,
  python3Packages,
  wrapGAppsHook4,
}:

python3Packages.buildPythonApplication {
  pname = "hyprmod";
  version = "0.1.0-unstable-2026-03-31";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "BlueManCZ";
    repo = "hyprmod";
    rev = "25cfc5ecef099a1cfbd9d059d522afd1a5ba4886";
    hash = "sha256-m0DLNcKwFG/LhZ0wRGuQTZCYC+6pasW8oFiOYBk7Mk4=";
  };

  build-system = with python3Packages; [ hatchling ];

  nativeBuildInputs = [
    glib # glib-compile-schemas for hatch build hook
    gobject-introspection
    wrapGAppsHook4
  ];

  buildInputs = [
    gnome-desktop
    gtk4
    libadwaita
  ];

  dependencies = with python3Packages; [
    hyprland-config
    hyprland-monitors
    hyprland-schema
    hyprland-socket
    hyprland-state
    pygobject3
    pygobject-stubs
  ];

  dontWrapGApps = true;

  preFixup = ''
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  pythonImportsCheck = [ "hyprmod" ];

  # tests require running Hyprland instance
  doCheck = false;

  meta = {
    description = "Native GTK4/libadwaita settings application for Hyprland";
    homepage = "https://github.com/BlueManCZ/hyprmod";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ sophronesis ];
    platforms = lib.platforms.linux;
    mainProgram = "hyprmod";
  };
}
