{
  lib,
  appstream,
  blueprint-compiler,
  desktop-file-utils,
  fetchFromGitHub,
  glib,
  glib-networking,
  gobject-introspection,
  gtk4,
  libadwaita,
  meson,
  ninja,
  pkg-config,
  python3Packages,
  wrapGAppsHook4,
}:

python3Packages.buildPythonApplication rec {
  pname = "cartridges";
  version = "2.10.1";
  pyproject = false;

  src = fetchFromGitHub {
    owner = "kra-mo";
    repo = "cartridges";
    rev = "refs/tags/v${version}";
    hash = "sha256-uwU0jW5+33hiqpuG83r0GVfANl6ltDLa3s4s0IJHRoQ=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    appstream
    blueprint-compiler
    desktop-file-utils # for `desktop-file-validate`
    glib # for `glib-compile-schemas`
    gtk4 # for `gtk-update-icon-cache`
    gobject-introspection
    meson
    ninja
    pkg-config
    wrapGAppsHook4
  ];

  buildInputs = [
    glib-networking
    libadwaita
  ];

  dependencies = with python3Packages; [
    pillow
    pygobject3
    pyyaml
    requests
  ];

  dontWrapGApps = true;
  makeWrapperArgs = [ "\${gappsWrapperArgs[@]}" ];

  postFixup = ''
    wrapPythonProgramsIn $out/libexec $out $pythonPath
  '';

  # NOTE: `postCheck` is intentionally not used here, as the entire checkPhase
  # is skipped by `buildPythonApplication`
  # https://github.com/NixOS/nixpkgs/blob/9d4343b7b27a3e6f08fc22ead568233ff24bbbde/pkgs/development/interpreters/python/mk-python-derivation.nix#L296
  postInstallCheck = ''
    mesonCheckPhase
  '';

  meta = {
    description = "GTK4 + Libadwaita game launcher";
    longDescription = ''
      A simple game launcher for all of your games.
      It has support for importing games from Steam, Lutris, Heroic
      and more with no login necessary.
      You can sort and hide games or download cover art from SteamGridDB.
    '';
    homepage = "https://apps.gnome.org/Cartridges/";
    changelog = "https://github.com/kra-mo/cartridges/releases/tag/${version}";
    license = lib.licenses.gpl3Plus;
    maintainers = lib.teams.gnome-circle.members;
    mainProgram = "cartridges";
    platforms = lib.platforms.linux;
  };
}
