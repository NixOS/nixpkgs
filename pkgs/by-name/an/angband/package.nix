{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  nix-update-script,
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
    tag = "${finalAttrs.version}";
    hash = "sha256-lx2EfE3ylcH1vLAHwNT1me1l4e4Jspkw4YJIAOlu/0E=";
  };

  passthru.updateScript = nix-update-script { };

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

  enableParallelBuilding = true;

  configureFlags = lib.optional enableSdl2 "--enable-sdl2";

  installFlags = [ "bindir=$(out)/bin" ];

  meta = {
    homepage = "https://angband.github.io/angband";
    description = "Single-player roguelike dungeon exploration game";
    mainProgram = "angband";
    maintainers = [ lib.maintainers.kenran ];
    changelog = "https://github.com/angband/angband/releases/tag/${finalAttrs.version}";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.unix;
  };
})
