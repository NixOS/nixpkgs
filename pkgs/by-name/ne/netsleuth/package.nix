{
  lib,
  python3Packages,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  appstream,
  desktop-file-utils,
  gobject-introspection,
  wrapGAppsHook4,
  libadwaita,
}:
python3Packages.buildPythonApplication rec {
  pname = "netsleuth";
  version = "1.1.1";
  pyproject = false;

  src = fetchFromGitHub {
    owner = "vmkspv";
    repo = "netsleuth";
    tag = "v${version}";
    hash = "sha256-dExIPrXP/eELkici+b3RQKyxoQ/Cgsfy0+08KpxDWug=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    appstream
    desktop-file-utils
    gobject-introspection
    wrapGAppsHook4
  ];

  buildInputs = [
    libadwaita
  ];

  dependencies = with python3Packages; [
    pygobject3
  ];

  dontWrapGApps = true;

  makeWrapperArgs = [ "\${gappsWrapperArgs[@]}" ];

  meta = {
    description = "Simple utility for the calculation and analysis of IP subnet values, designed to simplify network configuration tasks";
    homepage = "https://github.com/vmkspv/netsleuth";
    changelog = "https://github.com/vmkspv/netsleuth/releases/tag/${src.tag}";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ Cameo007 ];
    mainProgram = "netsleuth";
  };
}
