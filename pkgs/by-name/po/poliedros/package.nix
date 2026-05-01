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
  libadwaita,
  nix-update-script,
}:
let
  version = "1.5.2";
in
python3Packages.buildPythonApplication {
  pname = "poliedros";
  inherit version;
  pyproject = false;

  src = fetchFromGitHub {
    owner = "kriptolix";
    repo = "Poliedros";
    tag = "v${version}";
    hash = "sha256-1xrXR0kY4zq2cafhVgPvWcJD7pEEiZX7tW1/T3Mfe+A=";
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

  pythonPath = [ python3Packages.pygobject3 ];

  buildInputs = [ libadwaita ];

  dontWrapGApps = true;

  makeWrapperArgs = [ "\${gappsWrapperArgs[@]}" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Multi-type dice roller";
    homepage = "https://github.com/kriptolix/Poliedros";
    changelog = "https://github.com/kriptolix/Poliedros/releases/tag/v${version}";
    license = lib.licenses.gpl3Plus;
    mainProgram = "poliedros";
    maintainers = [ lib.maintainers.da157 ];
  };
}
