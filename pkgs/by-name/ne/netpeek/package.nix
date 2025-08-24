{
  lib,
  python3Packages,
  fetchFromGitHub,
  meson,
  ninja,
  appstream,
  desktop-file-utils,
  gobject-introspection,
  wrapGAppsHook4,
  pkg-config,
  libadwaita,
  libportal-gtk4,
  gnome,
}:
python3Packages.buildPythonApplication rec {
  pname = "netpeek";
  version = "0.2.3.1";
  pyproject = false;

  src = fetchFromGitHub {
    owner = "ZingyTomato";
    repo = "NetPeek";
    tag = "v${version}";
    hash = "sha256-3PbGK8e/W4pHlXwIvW6kmyeBMvzBIS2DrV0pxafgJOY=";
  };

  nativeBuildInputs = [
    meson
    ninja
    appstream
    desktop-file-utils
    gobject-introspection
    wrapGAppsHook4
    pkg-config
  ];

  buildInputs = [
    libadwaita
    libportal-gtk4
  ];

  dependencies = with python3Packages; [
    pygobject3
    ping3
  ];

  dontWrapGApps = true;

  preFixup = ''
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  meta = {
    description = "Modern network scanner for GNOME";
    homepage = "https://github.com/ZingyTomato/NetPeek";
    changelog = "https://github.com/ZingyTomato/NetPeek/releases/tag/${src.tag}";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ Cameo007 ];
    mainProgram = "netpeek";
    platforms = lib.platforms.linux;
  };
}
