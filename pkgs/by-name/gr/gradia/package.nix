{
  lib,
  gtk4,
  ninja,
  meson,
  libportal,
  libadwaita,
  wrapGAppsHook4,
  fetchFromGitHub,
  python3Packages,
  nix-update-script,
  blueprint-compiler,
  desktop-file-utils,
  gobject-introspection,
}:
python3Packages.buildPythonApplication rec {
  pname = "gradia";
  version = "1.4.0";
  format = "other";

  src = fetchFromGitHub {
    owner = "AlexanderVanhee";
    repo = "gradia";
    tag = "v${version}";
    hash = "sha256-9iXz4MjgG4VlystZZIKOheK4hYuz6lRXPivy+1K+cYs=";
  };

  nativeBuildInputs = [
    gtk4
    meson
    ninja
    wrapGAppsHook4
    blueprint-compiler
    desktop-file-utils
    gobject-introspection
  ];

  dependencies = with python3Packages; [
    pillow
    pycairo
    pygobject3
    pygobject-stubs
  ];

  buildInputs = [
    libportal
    libadwaita
  ];

  passthru.updateScript = nix-update-script { };

  dontWrapGApps = true;
  makeWrapperArgs = [ "\${gappsWrapperArgs[@]}" ];

  meta = {
    changelog = "https://github.com/AlexanderVanhee/Gradia/releases/tag/${version}";
    description = "Make your screenshots ready for the world";
    homepage = "https://github.com/AlexanderVanhee/Gradia";
    license = lib.licenses.gpl3Only;
    mainProgram = "gradia";
    maintainers = with lib.maintainers; [ quadradical ];
    platforms = lib.platforms.linux;
  };
}
