{
  lib,
  SDL,
  SDL_image,
  SDL_mixer,
  SDL_ttf,
  buildEnv,
  fetchurl,
  guile,
  lzip,
  pkg-config,
  stdenv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "guile-sdl";
  version = "0.6.1";

  src = fetchurl {
    url = "mirror://gnu/guile-sdl/guile-sdl-${finalAttrs.version}.tar.lz";
    hash = "sha256-/9sTTvntkRXck3FoRalROjqUQC8hkePtLTnHNZotKOE=";
  };

  nativeBuildInputs = [
    SDL
    guile
    lzip
    pkg-config
  ];

  configureFlags = [
    (lib.enableFeature (!stdenv.hostPlatform.isDarwin) "sdltest")
  ];

  buildInputs = [
    (lib.getDev SDL)
    (lib.getDev SDL_image)
    (lib.getDev SDL_mixer)
    (lib.getDev SDL_ttf)
    guile
  ];

  makeFlags =
    let
      sdl-env = buildEnv {
        name = "sdl-env";
        paths = finalAttrs.buildInputs;
      };
    in
    [
      "SDLMINUSI=-I${sdl-env}/include/SDL"
    ];

  strictDeps = true;

  meta = {
    # clang-16: error: unsupported option '--visibility=hidden'; did you mean '-fvisibility=hidden'
    broken = stdenv.hostPlatform.isDarwin;
    homepage = "https://www.gnu.org/software/guile-sdl/";
    description = "Guile bindings for SDL";
    license = lib.licenses.gpl3Plus;
    maintainers = lib.teams.sdl.members ++ (with lib.maintainers; [ ]);
    inherit (guile.meta) platforms;
  };
})
