{
  lib,
  appstream,
  blueprint-compiler,
  desktop-file-utils,
  fetchFromGitHub,
  glib,
  gobject-introspection,
  gtk4,
  libadwaita,
  meson,
  ninja,
  nix-update-script,
  pkg-config,
  python3Packages,
  wrapGAppsHook4,
}:

python3Packages.buildPythonApplication rec {
  pname = "binary";
  version = "5.3";
  pyproject = false;

  src = fetchFromGitHub {
    owner = "fizzyizzy05";
    repo = "binary";
    tag = version;
    hash = "sha256-kJLEDE/jHKc/VDGa0lcm4eM7nEMam0fbEW8YJVfc7OY=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    appstream
    blueprint-compiler
    desktop-file-utils # for `desktop-file-validate`
    glib # for `glib-compile-schemas`
    gobject-introspection
    gtk4 # for `gtk-update-icon-cache`
    meson
    ninja
    pkg-config
    wrapGAppsHook4
  ];

  buildInputs = [ libadwaita ];

  dependencies = with python3Packages; [ pygobject3 ];

  dontWrapGApps = true;
  makeWrapperArgs = [ "\${gappsWrapperArgs[@]}" ];

  # NOTE: `postCheck` is intentionally not used here, as the entire checkPhase
  # is skipped by `buildPythonApplication`
  # https://github.com/NixOS/nixpkgs/blob/9d4343b7b27a3e6f08fc22ead568233ff24bbbde/pkgs/development/interpreters/python/mk-python-derivation.nix#L296
  postInstallCheck = ''
    mesonCheckPhase
  '';

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Small and simple app to convert numbers to a different base";
    homepage = "https://github.com/fizzyizzy05/binary";
    changelog = "https://github.com/fizzyizzy05/binary/releases/tag/${version}";
    license = lib.licenses.gpl3Plus;
    teams = [ lib.teams.gnome-circle ];
    mainProgram = "binary";
    platforms = lib.platforms.linux;
  };
}
