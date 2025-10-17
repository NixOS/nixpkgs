{
  lib,
  stdenv,
  fetchurl,
  libX11,
  SDL,
  libGLU,
  libGL,
  expat,
  zlib,
  SDL_ttf,
  SDL_image,
}:

stdenv.mkDerivation (finalAttrs: {
  version = "1.5.0";
  pname = "bloodspilot-client";

  src = fetchurl {
    url = "mirror://sourceforge/project/bloodspilot/client-sdl/v${finalAttrs.version}/bloodspilot-client-sdl-${finalAttrs.version}.tar.gz";
    hash = "sha256-svOVg8b33cUpsesd9Xq8PRHvnZFKnxoA/cKqslVJlOM=";
  };

  patches = [ ./bloodspilot-sdl-window-fix.patch ];

  buildInputs = [
    libX11
    SDL
    SDL_ttf
    SDL_image
    libGLU
    libGL
    expat
    zlib
  ];

  NIX_LDFLAGS = "-lX11";

  meta = {
    description = "Multiplayer space combat game (client part)";
    mainProgram = "bloodspilot-client-sdl";
    homepage = "http://bloodspilot.sf.net/";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [
      raskin
      iedame
    ];
    platforms = lib.platforms.linux;
  };
})
