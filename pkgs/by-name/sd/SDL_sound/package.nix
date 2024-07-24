{
  lib,
  SDL,
  fetchurl,
  flac,
  libmikmod,
  libvorbis,
  stdenv,
  # Boolean flags
  enableSdltest ? (!stdenv.isDarwin)
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "SDL_sound";
  version = "1.0.3";

  src = fetchurl {
    url = "https://icculus.org/SDL_sound/downloads/SDL_sound-${finalAttrs.version}.tar.gz";
    hash = "sha256-OZn9C7tIUomlK+FLL2i1ccuE44DMQzh+rfd49kx55t8=";
  };

  nativeBuildInputs = [
    SDL
  ];

  buildInputs = [
    SDL
    flac
    libmikmod
    libvorbis
  ];

  configureFlags = [
    (lib.enableFeature enableSdltest "--disable-sdltest")
  ];

  strictDeps = true;

  meta = {
    homepage = "https://www.icculus.org/SDL_sound/";
    description = "SDL sound library";
    license = lib.licenses.lgpl21Plus;
    maintainers = lib.teams.sdl.members
                  ++ (with lib.maintainers; [ ]);
    mainProgram = "playsound";
    inherit (SDL.meta) platforms;
  };
})
