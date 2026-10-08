{
  lib,
  python3Packages,
  fetchFromCodeberg,
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
  version = "3";
in
python3Packages.buildPythonApplication {
  pname = "nucleus";
  inherit version;
  pyproject = false;

  src = fetchFromCodeberg {
    owner = "lo-vely";
    repo = "nucleus";
    tag = "v${version}";
    hash = "sha256-0IuFKOadweGYvflCN2c1hvW+X4GzvqG8ZRhPzuVSBr8=";
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

  dependencies = with python3Packages; [
    pygobject3
  ];

  buildInputs = [
    libadwaita
  ];

  dontWrapGApps = true;
  makeWrapperArgs = [ "\${gappsWrapperArgs[@]}" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Unofficial GNOME Periodic Table";
    homepage = "https://codeberg.org/lo-vely/nucleus";
    changelog = "https://codeberg.org/lo-vely/nucleus/releases/tag/v${version}";
    license = lib.licenses.gpl3Plus;
    mainProgram = "nucleus";
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.da157 ];
  };
}
