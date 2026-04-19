{
  lib,
  fetchFromGitHub,
  python3Packages,
  copyDesktopItems,
  gobject-introspection,
  gtk4,
  libadwaita,
  makeDesktopItem,
  wrapGAppsHook4,
}:

python3Packages.buildPythonApplication {
  pname = "nirimod";
  version = "0-unstable-2026-04-18";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "srinivasr";
    repo = "nirimod";
    rev = "6dbda782788caed4e8691e372e79b5c73d6871ba";
    hash = "sha256-l3q0hxUpgW7Fmb2zz3IY+dhbTffhUy2oYc80sf6p6LA=";
  };

  build-system = [ python3Packages.hatchling ];

  nativeBuildInputs = [
    copyDesktopItems
    gobject-introspection
    wrapGAppsHook4
  ];

  buildInputs = [
    gtk4
    libadwaita
  ];

  dependencies = [ python3Packages.pygobject3 ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail 'nirimod = "nirimod.main:main"' 'nirimod = "nirimod.__main__:main"'
  '';

  postInstall = ''
    install -Dm644 data/nirimod.svg $out/share/icons/hicolor/scalable/apps/nirimod.svg
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "io.github.nirimod";
      exec = "nirimod";
      icon = "nirimod";
      desktopName = "NiriMod";
      genericName = "Compositor Settings";
      comment = "GUI configuration manager for the niri Wayland compositor";
      categories = [
        "Utility"
        "Settings"
        "DesktopSettings"
      ];
      keywords = [
        "compositor"
        "windowmanager"
        "wayland"
        "niri"
        "settings"
        "config"
      ];
      startupNotify = true;
      startupWMClass = "nirimod";
    })
  ];

  dontWrapGApps = true;

  preFixup = ''
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  meta = {
    description = "Visual configuration interface for the niri Wayland compositor";
    homepage = "https://github.com/srinivasr/nirimod";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sophronesis ];
    platforms = lib.platforms.linux;
    mainProgram = "nirimod";
  };
}
