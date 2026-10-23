{
  lib,
  fetchFromGitHub,
  python3Packages,
  copyDesktopItems,
  gobject-introspection,
  gtk4,
  libadwaita,
  makeDesktopItem,
  unstableGitUpdater,
  wrapGAppsHook4,
}:

python3Packages.buildPythonApplication {
  pname = "nirimod";
  version = "0-unstable-2026-10-01";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "srinivasr";
    repo = "nirimod";
    rev = "f29cf679b8ac3a07f96828880fb983f6432549f1";
    hash = "sha256-uNkgFu5ntt873eA5u2pSfH6BQPhqDl0gcZupaFKG8SM=";
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

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    description = "Visual configuration interface for the niri Wayland compositor";
    homepage = "https://github.com/srinivasr/nirimod";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sophronesis ];
    platforms = lib.platforms.linux;
    mainProgram = "nirimod";
  };
}
