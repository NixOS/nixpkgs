{
  lib,
  python3Packages,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  gobject-introspection,
  blueprint-compiler,
  wrapGAppsHook4,
  desktop-file-utils,
  libadwaita,
  gtksourceview5,
}:

python3Packages.buildPythonApplication rec {
  pname = "escambo";
  version = "0.1.2";
  pyproject = false; # built with meson

  src = fetchFromGitHub {
    owner = "CleoMenezesJr";
    repo = "escambo";
    rev = version;
    hash = "sha256-jMlix8nlCaVLZEhqzb6LRNrD3DUZMTIjqrRKo6nFbQA=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    gobject-introspection
    blueprint-compiler
    wrapGAppsHook4
    desktop-file-utils
  ];

  buildInputs = [
    libadwaita
    gtksourceview5
  ];

  dependencies = with python3Packages; [
    pygobject3
    requests
  ];

  dontWrapGApps = true;

  preFixup = ''
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  meta = {
    description = "HTTP-based APIs test application for GNOME";
    homepage = "https://github.com/CleoMenezesJr/escambo";
    license = lib.licenses.gpl3Plus;
    mainProgram = "escambo";
    maintainers = with lib.maintainers; [ aleksana ];
    platforms = lib.platforms.linux;
  };
}
