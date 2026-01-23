{
  lib,
  appstream,
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
  ffmpeg-headless,
}:

python3Packages.buildPythonApplication rec {
  pname = "drum-machine";
  version = "1.5.0";
  pyproject = false;

  src = fetchFromGitHub {
    owner = "Revisto";
    repo = "drum-machine";
    tag = "v${version}";
    hash = "sha256-F3h3BxLNkJq0jpfNOGcTbckpc8CksyA3Bc8GNKviB+I=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    appstream
    desktop-file-utils
    glib
    gobject-introspection
    gtk4 # For `gtk-update-icon-theme`
    meson
    ninja
    pkg-config
    wrapGAppsHook4
  ];

  buildInputs = [ libadwaita ];

  dependencies = with python3Packages; [
    mido
    pygame
    pygobject3
    numpy
  ];

  dontWrapGApps = true;

  makeWrapperArgs = [
    "\${gappsWrapperArgs[@]}"
    "--prefix PATH : ${lib.makeBinPath [ ffmpeg-headless ]}"
  ];

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
    description = "Modern and intuitive application for creating, playing, and managing drum patterns";
    homepage = "https://apps.gnome.org/DrumMachine";
    changelog = "https://github.com/Revisto/drum-machine/releases/tag/${src.tag}";
    license = lib.licenses.gpl3Plus;
    teams = [ lib.teams.gnome-circle ];
    platforms = lib.platforms.linux;
  };
}
