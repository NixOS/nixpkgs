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
  gobject-introspection,
  gtk4,
  libadwaita,
  nix-update-script,
}:
let
  version = "0.5.1";
in
python3Packages.buildPythonApplication {
  pname = "pigment";
  inherit version;
  pyproject = false;

  src = fetchFromGitHub {
    owner = "Jeffser";
    repo = "Pigment";
    tag = version;
    hash = "sha256-tWWDX1njnI1FOZhTUE1i+5pqZeLZFzHBrfoGFHCKnX0=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    wrapGAppsHook4
    glib
    desktop-file-utils
    appstream-glib
    gobject-introspection
  ];

  pythonPath = with python3Packages; [
    pygobject3
    colorthief
    pydbus
  ];

  buildInputs = [
    gtk4
    libadwaita
  ];

  dontWrapGApps = true;
  makeWrapperArgs = [ "\${gappsWrapperArgs[@]}" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Extract color palettes from your images";
    homepage = "https://jeffser.com/pigment/";
    downloadPage = "https://github.com/Jeffser/Pigment";
    changelog = "https://github.com/Jeffser/Pigment/releases/tag/${version}";
    license = lib.licenses.gpl3Plus;
    mainProgram = "pigment";
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.awwpotato ];
  };
}
