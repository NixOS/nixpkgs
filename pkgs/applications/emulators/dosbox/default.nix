{ lib
, stdenv
, fetchurl
, autoreconfHook
, SDL_compat
, SDL_net
, SDL_sound
, copyDesktopItems
, graphicsmagick
, libGL
, libGLU
, libpng
, makeDesktopItem
}:

stdenv.mkDerivation rec {
  pname = "dosbox";
  version = "0.74-3";

  src = fetchurl {
    url = "mirror://sourceforge/dosbox/dosbox-${version}.tar.gz";
    hash = "sha256-wNE91+0u02O2jeYVR1eB6JHNWC6BYrXDZpE3UCIiJgo=";
  };

  nativeBuildInputs = [
    autoreconfHook
    copyDesktopItems
    graphicsmagick
  ];

  buildInputs = [
    SDL_compat
    SDL_net
    SDL_sound
    libGL
    libGLU
    libpng
  ];

  hardeningDisable = [ "format" ];

  configureFlags = lib.optional stdenv.isDarwin "--disable-sdltest";

  desktopItems = [
    (makeDesktopItem {
      name = "dosbox";
      exec = "dosbox";
      icon = "dosbox";
      comment = "x86 dos emulator";
      desktopName = "DOSBox";
      genericName = "DOS emulator";
      categories = [ "Emulator" "Game" ];
    })
  ];

  postInstall = ''
     mkdir -p $out/share/icons/hicolor/256x256/apps
     gm convert src/dosbox.ico $out/share/icons/hicolor/256x256/apps/dosbox.png
  '';

  enableParallelBuilding = true;

  meta = with lib; {
    homepage = "http://www.dosbox.com/";
    description = "A DOS emulator";
    longDescription = ''
      DOSBox is an emulator that recreates a MS-DOS compatible environment
      (complete with Sound, Input, Graphics and even basic networking). This
      environment is complete enough to run many classic MS-DOS games completely
      unmodified. In order to utilize all of DOSBox's features you need to first
      understand some basic concepts about the MS-DOS environment.
    '';
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ matthewbauer ];
    platforms = platforms.unix;
  };
}
