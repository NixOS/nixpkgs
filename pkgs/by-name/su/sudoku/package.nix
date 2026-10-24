{
  lib,
  blueprint-compiler,
  desktop-file-utils,
  fetchFromGitHub,
  gtk4,
  libadwaita,
  meson,
  ninja,
  python3,
  stdenv,
  wrapGAppsHook4,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "sudoku";
  version = "1.6.1";

  src = fetchFromGitHub {
    owner = "sepehr-rs";
    repo = "Sudoku";
    tag = "v${finalAttrs.version}";
    hash = "sha256-xO/UlRGkfFwU8IGA5e5/wRHbWgMqXW/IDHL4GzwFDjk=";
  };

  nativeBuildInputs = [
    blueprint-compiler
    desktop-file-utils
    meson
    ninja
    wrapGAppsHook4
  ];

  buildInputs = [
    gtk4
    libadwaita
    (python3.withPackages (
      ps: with ps; [
        pygobject3
        sudoku-engine
      ]
    ))
  ];

  meta = {
    description = "A modern Sudoku app built with Python, GTK4 and libadwaita";
    changelog = "https://github.com/sepehr-rs/Sudoku/releases/tag/v${finalAttrs.version}";
    homepage = "https://github.com/sepehr-rs/Sudoku";
    license = lib.licenses.gpl3Plus;
    teams = [ lib.teams.gnome-circle ];
    mainProgram = "sudokugame";
    platforms = lib.platforms.all;
  };
})
