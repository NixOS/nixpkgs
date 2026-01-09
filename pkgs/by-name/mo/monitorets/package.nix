{
  lib,
  python3Packages,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  gobject-introspection,
  wrapGAppsHook4,
  desktop-file-utils,
  libadwaita,
}:

python3Packages.buildPythonApplication rec {
  pname = "monitorets";
  version = "0.10.1";
  # built with meson, not a python format
  pyproject = false;

  src = fetchFromGitHub {
    owner = "jorchube";
    repo = "monitorets";
    tag = version;
    hash = "sha256-Y6cd9Wf2IzHwdxzLUP/U4rervlPUr8s2gKSW8y5I7bg=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    gobject-introspection
    wrapGAppsHook4
    desktop-file-utils
  ];

  buildInputs = [ libadwaita ];

  dependencies = with python3Packages; [
    pygobject3
    xdg
    psutil
  ];

  dontWrapGApps = true;

  preFixup = ''
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  meta = {
    description = "Simple and quick view at the usage of your computer resources";
    homepage = "https://github.com/jorchube/monitorets";
    license = with lib.licenses; [
      gpl3Plus
      cc0
    ];
    mainProgram = "monitorets";
    maintainers = with lib.maintainers; [ aleksana ];
    platforms = lib.platforms.linux;
  };
}
