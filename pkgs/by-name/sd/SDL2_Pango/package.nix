{
  lib,
  SDL2,
  autoreconfHook,
  fetchFromGitHub,
  freetype,
  pango,
  pkg-config,
  stdenv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "sdl2-pango";
  version = "2.1.5";

  src = fetchFromGitHub {
    owner = "markuskimius";
    repo = "SDL2_Pango";
    rev = "v${finalAttrs.version}";
    hash = "sha256-8SL5ylxi87TuKreC8m2kxlLr8rcmwYYvwkp4vQZ9dkc=";
  };

  nativeBuildInputs = [
    SDL2
    autoreconfHook
    pkg-config
  ];

  buildInputs = [
    SDL2
    freetype
    pango
  ];

  outputs = [
    "out"
    "dev"
  ];

  strictDeps = true;

  meta = {
    homepage = "https://github.com/markuskimius/SDL2_Pango";
    description = "Library for graphically rendering internationalized and tagged text in SDL2 using TrueType fonts";
    license = lib.licenses.lgpl21Plus;
    maintainers = with lib.maintainers; [ rardiol ];
    teams = [ lib.teams.sdl ];
    inherit (SDL2.meta) platforms;
  };
})
