{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "snake";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "imApeki";
    repo = "snake";
    tag = "v${version}";
    hash = "sha256-K334XuyOA6bQ10gNW56dWYRxLkfwj2wcx0Cue8tNd/U=";
  };

  cargoHash = "sha256-z5EHky1BqLOIolTYOKTEPMKq83fs4+SYODjpI/l9FYk=";

  meta = {
    description = "TUI snake game with menu, highscores, obstacles and adaptive terminal size";
    longDescription = ''
      A terminal snake game featuring an animated main menu, persistent
      highscores, periodic obstacles, adaptive field size that adjusts to your
      terminal dimensions, and support for any keyboard layout (QWERTY,
      ЙЦУКЕН, QWERTZ, AZERTY, etc.).
    '';
    homepage = "https://github.com/imApeki/snake"\;
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ imApeki ];
    mainProgram = "snake";
    platforms = lib.platforms.unix;
  };
}
