{
  lib,
  stdenv,
  fetchFromGitHub,
  withSDL ? false,
  ncurses,
  SDL,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "curseofwar";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "a-nikolaev";
    repo = "curseofwar";
    rev = "v${finalAttrs.version}";
    sha256 = "1wd71wdnj9izg5d95m81yx3684g4zdi7fsy0j5wwnbd9j34ilz1i";
  };

  buildInputs = [
    ncurses
    (if withSDL then SDL else null)
  ];

  makeFlags = (lib.optional withSDL "SDL=yes") ++ [
    "PREFIX=$(out)"
    # force platform's cc on darwin, otherwise gcc is used
    "CC=${stdenv.cc.targetPrefix}cc"
  ];

  meta = {
    description = "Fast-paced action strategy game";
    homepage = "https://a-nikolaev.github.io/curseofwar/";
    license = lib.licenses.gpl3;
    mainProgram = if withSDL then "curseofwar-sdl" else "curseofwar";
    maintainers = with lib.maintainers; [ fgaz ];
    platforms = lib.platforms.all;
  };
})
