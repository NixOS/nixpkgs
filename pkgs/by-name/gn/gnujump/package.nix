{
  lib,
  stdenv,
  makeDesktopItem,
  copyDesktopItems,
  fetchurl,
  libGL,
  libGLU,
  SDL,
  SDL_image,
  SDL_mixer,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gnujump";
  version = "1.0.8";
  src = fetchurl {
    url = "mirror://gnu/gnujump/gnujump-${finalAttrs.version}.tar.gz";
    sha256 = "05syy9mzbyqcfnm0hrswlmhwlwx54f0l6zhcaq8c1c0f8dgzxhqk";
  };

  nativeBuildInputs = [ copyDesktopItems ];
  buildInputs = [
    libGL
    libGLU
    SDL
    SDL_image
    SDL_mixer
  ];

  NIX_LDFLAGS = "-lm";

  desktopItems = [
    (makeDesktopItem {
      name = "gnujump";
      exec = "gnujump";
      icon = "gnujump";
      desktopName = "GNUjump";
      comment = "Jump up the tower to survive";
      categories = [
        "Game"
        "ArcadeGame"
      ];
    })
  ];

  postInstall = ''
    install -Dm644 ${./gnujump.xpm} $out/share/pixmaps/gnujump.xpm
  '';

  meta = with lib; {
    homepage = "https://jump.gnu.sinusoid.es/index.php?title=Main_Page";
    description = "Clone of the simple yet addictive game Xjump";
    mainProgram = "gnujump";
    longDescription = ''
      The goal in this game is to jump to the next floor trying not to fall
      down. As you go upper in the Falling Tower the floors will fall faster.
      Try to survive longer get upper than anyone. It might seem too simple but
      once you've tried you'll realize how addictive this is.
    '';
    license = licenses.gpl3;
    maintainers = with maintainers; [ fgaz ];
    platforms = platforms.linux;
  };
})
