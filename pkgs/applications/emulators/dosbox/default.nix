{ lib
, stdenv
, fetchurl
, fetchpatch
, autoreconfHook
, SDL
, SDL_net
, SDL_sound
, copyDesktopItems
, graphicsmagick
, libGL
, libGLU
, OpenGL
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

  patches = [
    (fetchpatch {
      url = "https://github.com/joncampbell123/dosbox-x/commit/006d5727d36d1ec598e387f2f1a3c521e3673dcb.patch";
      includes = [ "src/gui/render_templates_sai.h" ];
      hash = "sha256-HSO29/LgZRKQ3HQBA0QF5henG8pCSoe1R2joYNPcUcE=";
    })
  ];

  nativeBuildInputs = [
    autoreconfHook
    copyDesktopItems
    graphicsmagick
  ];

  buildInputs = [
    SDL
    SDL_net
    SDL_sound
    libpng
  ] ++ (if stdenv.hostPlatform.isDarwin then [
    OpenGL
  ] else [
    libGL
    libGLU
  ]);

  # Tests for SDL_net.h for modem & IPX support, not automatically picked up due to being in SDL subdirectory
  env.NIX_CFLAGS_COMPILE = "-I${lib.getDev SDL_net}/include/SDL";

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
    mainProgram = "dosbox";
  };
}
