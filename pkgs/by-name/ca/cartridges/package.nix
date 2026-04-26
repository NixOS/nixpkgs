{
  lib,
  appstream,
  blueprint-compiler,
  desktop-file-utils,
  fetchFromCodeberg,
  glib,
  glib-networking,
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

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "cartridges";
  version = "2.13.1";
  pyproject = false;

  src = fetchFromCodeberg {
    owner = "kramo";
    repo = "cartridges";
    tag = "v${finalAttrs.version}";
    hash = "sha256-VWOKsSOEAtngrDx7tJ+notoMBfBuO40Z2x9VTj710+8=";
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
    wrapPythonProgramsIn $out/libexec "$out ''${pythonPath[*]}"
  '';

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
    description = "GTK4 + Libadwaita game launcher";
    longDescription = ''
      A simple game launcher for all of your games.
      It has support for importing games from Steam, Lutris, Heroic
      and more with no login necessary.
      You can sort and hide games or download cover art from SteamGridDB.
    '';
    homepage = "https://apps.gnome.org/Cartridges/";
    changelog = "https://codeberg.org/kramo/cartridges/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Plus;
    teams = [ lib.teams.gnome-circle ];
    mainProgram = "cartridges";
    platforms = lib.platforms.linux;
  };
})
