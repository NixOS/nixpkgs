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
  blueprint-compiler,
  libadwaita,
  libportal-gtk4,
}:
python3Packages.buildPythonApplication rec {
  pname = "gradia";
  version = "1.4.3";
  pyproject = false;

  src = fetchFromGitHub {
    owner = "AlexanderVanhee";
    repo = "Gradia";
    tag = "v${version}";
    hash = "sha256-cH8aL1nvDNAnvN+TYAtGez5Ot5DmwpmxugBPS36rY+Q=";
  };

  nativeBuildInputs = [
    meson
    ninja
    appstream
    desktop-file-utils
    gobject-introspection
    wrapGAppsHook4
    blueprint-compiler
  ];

  buildInputs = [
    libadwaita
    libportal-gtk4
  ];

  dependencies = with python3Packages; [
    pygobject3
    pillow
  ];

  dontWrapGApps = true;

  makeWrapperArgs = [ "\${gappsWrapperArgs[@]}" ];

  meta = {
    description = "Make your screenshots ready for the world";
    homepage = "https://github.com/AlexanderVanhee/Gradia";
    changelog = "https://github.com/AlexanderVanhee/Gradia/releases/tag/${src.tag}";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [
      Cameo007
      quadradical
    ];
    mainProgram = "gradia";
    platforms = lib.platforms.linux;
  };
}
