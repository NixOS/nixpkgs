{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  boost,
  SDL2,
  SDL2_ttf,
  SDL2_image,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libwtk-sdl2";
  version = "0-unstable-2023-02-28";

  src = fetchFromGitHub {
    owner = "muesli4";
    repo = "libwtk-sdl2";
    rev = "0504f8342c8c97d0c8b43d33751427c564ad8d44";
    sha256 = "sha256-NAjsDQ4/hklYRfa85uleOr50tmc6UJVo2xiDnEbmIxk=";
  };

  nativeBuildInputs = [
    pkg-config
    autoreconfHook
  ];
  buildInputs = [
    boost
    SDL2
    SDL2_ttf
    SDL2_image
  ];
  # From some reason, this is needed as otherwise SDL.h is not found
  env.NIX_CFLAGS_COMPILE = "-I${lib.getInclude SDL2}/include/SDL2";

  outputs = [
    "out"
    "dev"
    "lib"
  ];

  meta = {
    description = "Simplistic SDL2 GUI framework in early developement";
    mainProgram = "libwtk-sdl2-test";
    homepage = "https://github.com/muesli4/libwtk-sdl2";
    # See: https://github.com/muesli4/mpd-touch-screen-gui/tree/master/LICENSES
    license = lib.licenses.lgpl3Plus;
    maintainers = with lib.maintainers; [ doronbehar ];
    /*
      Partial darwin build failure log (from ofborg):
      geometry.cpp:95:34: error: no member named 'abs' in namespace 'std'
         >     return { std::abs(v.w), std::abs(v.h) };
         >                             ~~~~~^
    */
    platforms = lib.platforms.linux;
  };
})
