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

python3Packages.buildPythonPackage rec {
  pname = "iplookup-gtk";
  version = "0.4.1";
  pyproject = false; # Built with meson

  src = fetchFromGitHub {
    owner = "Bytezz";
    repo = "IPLookup-gtk";
    tag = "v${version}";
    hash = "sha256-WXLT7ThuD4/alb44mkGNLJjZPiWgNmSUqsRiO+cjdPk=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    gobject-introspection
    wrapGAppsHook4
    desktop-file-utils
  ];

  buildInputs = [
    libadwaita
  ];

  dependencies = with python3Packages; [
    pygobject3
  ];

  dontWrapGApps = true;

  preFixup = ''
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  meta = {
    description = "Find info about an IP address";
    homepage = "https://github.com/Bytezz/IPLookup-gtk";
    changelog = "https://github.com/Bytezz/IPLookup-gtk/releases/tag/${src.tag}";
    license = lib.licenses.gpl3Plus;
    mainProgram = "iplookup";
    maintainers = with lib.maintainers; [ aleksana ];
    platforms = lib.platforms.linux;
  };
}
