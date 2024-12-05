{
  lib,
  SDL,
  fetchurl,
  stdenv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "SDL_stretch";
  version = "0.3.1";

  src = fetchurl {
    url = "mirror://sourceforge/sdl-stretch/${finalAttrs.version}/SDL_stretch-${finalAttrs.version}.tar.bz2";
    hash = "sha256-fL8L+rAMPt1uceGH0qLEgncEh4DiySQIuqt7YjUy/Nc=";
  };

  nativeBuildInputs = [ SDL ];

  configureFlags = [
    (lib.enableFeature (!stdenv.hostPlatform.isDarwin) "sdltest")
  ];

  buildInputs = [ SDL ];

  strictDeps = true;

  meta = {
    # sdlstretchcode.c:38:10: fatal error: 'malloc.h' file not found
    broken = stdenv.hostPlatform.isDarwin;
    homepage = "https://sdl-stretch.sourceforge.net/";
    description = "Stretch Functions For SDL";
    license = lib.licenses.lgpl2;
    maintainers = lib.teams.sdl.members ++ (with lib.maintainers; [ ]);
    inherit (SDL.meta) platforms;
  };
})
