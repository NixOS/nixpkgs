{
  lib,
  SDL,
  autoreconfHook,
  fetchpatch,
  fetchurl,
  pango,
  pkg-config,
  stdenv,
  # Boolean flags
  enableSdltest ? (!stdenv.isDarwin),
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "SDL_Pango";
  version = "0.1.2";

  src = fetchurl {
    url = "mirror://sourceforge/sdlpango/SDL_Pango-${finalAttrs.version}.tar.gz";
    hash = "sha256-f3XTuXrPcHxpbqEmQkkGIE6/oHZgFi3pJRc83QJX66Q=";
  };

  patches = [
    (fetchpatch {
      name = "0000-api_additions.patch";
      url = "https://sources.debian.org/data/main/s/sdlpango/0.1.2-6/debian/patches/api_additions.patch";
      hash = "sha256-jfr+R4tIVZfYoaY4i+aNSGLwJGEipnuKqD2O9orP5QI=";
    })
    ./0001-fixes.patch
  ];

  nativeBuildInputs = [
    SDL
    autoreconfHook
    pkg-config
  ];

  buildInputs = [
    SDL
    pango
  ];

  configureFlags = [
    (lib.enableFeature enableSdltest "sdltest")
  ];

  strictDeps = true;

  meta = {
    homepage = "https://sdlpango.sourceforge.net/";
    description = "Connects the Pango rendering engine to SDL";
    license = lib.licenses.lgpl21Plus;
    maintainers = lib.teams.sdl.members
                  ++ (with lib.maintainers; [ puckipedia ]);
    inherit (SDL.meta) platforms;
  };
})
