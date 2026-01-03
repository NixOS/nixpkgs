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
  version = "4.2.5";

  src = fetchFromGitHub {
    owner = "angband";
    repo = "angband";
    rev = finalAttrs.version;
    hash = "sha256-XH2FUTJJaH5TqV2UD1CKKAXE4CRAb6zfg1UQ79a15k0=";
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
