{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  ncurses5,
  enableSdl2 ? false,
  SDL2,
  SDL2_image,
  SDL2_mixer,
  SDL2_ttf,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "angband";
  version = "4.2.6";

  src = fetchFromGitHub {
    owner = "angband";
    repo = "angband";
    rev = finalAttrs.version;
    hash = "sha256-lx2EfE3ylcH1vLAHwNT1me1l4e4Jspkw4YJIAOlu/0E=";
  };

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [
    ncurses5
  ]
  ++ lib.optionals enableSdl2 [
    SDL2
    SDL2_image
    SDL2_mixer
    SDL2_ttf
  ];

  configureFlags = lib.optional enableSdl2 "--enable-sdl2";

  installFlags = [ "bindir=$(out)/bin" ];

  meta = {
    homepage = "https://angband.github.io/angband";
    description = "Single-player roguelike dungeon exploration game";
    mainProgram = "angband";
    maintainers = [ lib.maintainers.kenran ];
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.unix;
  };
})
