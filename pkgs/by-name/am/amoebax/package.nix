{
  fetchurl,
  lib,
  SDL,
  SDL_image,
  SDL_mixer,
  stdenv,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "amoebax";
  version = "0.2.1";
  src = fetchurl {
    url = "https://www.emma-soft.com/games/amoebax/download/amoebax-${finalAttrs.version}.tar.bz2";
    hash = "sha256-cJx+ZXsyim99MxKYxiZPFyUoSJ0oyrEHxAxIPDkjQLI=";
  };

  buildInputs = [
    SDL
    SDL_image
    SDL_mixer
  ];

  configureFlags = [
    "ac_cv_file__proc_self_maps=y"
  ];

  env.NIX_CFLAGS_COMPILE = "-fpermissive";
  env.SDL_CONFIG = lib.getExe' (lib.getDev SDL) "sdl-config";

  strictDeps = true;

  meta = {
    homepage = "https://www.emma-soft.com/games/amoebax/";
    description = "Cross-platform free Puyo-Puyo clone";
    longDescription = ''
      Amoebax is a free multi-platform match-3 puzzle game where the objective
      is to beat your opponent in a battle by filling their grid up to the top
      with garbage.

      You can play as Kim or Tom against six cute creatures controlled by the
      amoebas or you can play up to four players in a tournament to check out
      who is the amoebas' master.
    '';
    license = lib.licenses.gpl2Plus;
    mainProgram = "amoebax";
    maintainers = with lib.maintainers; [ colinsane ];
    platforms = lib.platforms.all;
    broken = stdenv.hostPlatform.isDarwin;
  };
})
