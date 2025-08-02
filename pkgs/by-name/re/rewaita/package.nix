{
  lib,
  python3Packages,
  fetchFromGitHub,
  ninja,
  meson,
  pkg-config,
  wrapGAppsHook4,
  glib,
  desktop-file-utils,
  appstream-glib,
  blueprint-compiler,
  libadwaita,
  nix-update-script,
}:
let
  version = "1.0.1";
in
python3Packages.buildPythonApplication {
  pname = "rewaita";
  inherit version;
  pyproject = false;

  src = fetchFromGitHub {
    owner = "SwordPuffin";
    repo = "Rewaita";
    tag = "v${version}";
    hash = "sha256-adSXq+DFw3IQxNuUkP1FcKlIh9h4Zb0tJKswYs3S92E=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    wrapGAppsHook4
    glib
    desktop-file-utils
    appstream-glib
    blueprint-compiler
  ];

  pythonPath = with python3Packages; [
    pygobject3
  ];

  buildInputs = [
    libadwaita
  ];

  dontWrapGApps = true;
  makeWrapperArgs = [ "\${gappsWrapperArgs[@]}" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Bring color to Adwaita";
    homepage = "https://github.com/SwordPuffin/Rewaita";
    changelog = "https://github.com/SwordPuffin/Rewaita/releases/tag/v${version}";
    license = lib.licenses.gpl3Plus;
    mainProgram = "rewaita";
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.awwpotato ];
  };
}
