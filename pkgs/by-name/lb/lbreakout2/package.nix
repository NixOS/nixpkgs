{
  lib,
  SDL,
  SDL_mixer,
  fetchpatch,
  fetchurl,
  libintl,
  libpng,
  stdenv,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "lbreakout2";
  version = "2.6.5";

  src = fetchurl {
    url = "mirror://sourceforge/lgames/lbreakout2-${finalAttrs.version}.tar.gz";
    hash = "sha256-kQTWF1VT2jRC3GpfxAemaeL1r/Pu3F0wQJ6wA7enjW8=";
  };

  patches = [
    (fetchpatch {
      url = "https://sources.debian.org/data/main/l/lbreakout2/2.6.5-2/debian/patches/sdl_fix_pauses.patch";
      hash = "sha256-ycsuxfokpOblLky42MwtJowdEp7v5dZRMFIR4id4ZBI=";
    })
  ];

  buildInputs = [
    SDL
    SDL_mixer
    libintl
    libpng
    zlib
  ];

  # With fortify it crashes at runtime:
  #   *** buffer overflow detected ***: terminated
  #   Aborted (core dumped)
  hardeningDisable = [ "fortify" ];

  meta = {
    homepage = "http://lgames.sourceforge.net/LBreakout2/";
    description = "Breakout clone from the LGames series";
    license = with lib.licenses; [ gpl2Plus ];
    mainProgram = "lbreakout2";
    maintainers = with lib.maintainers; [
      AndersonTorres
      ciil
    ];
    platforms = lib.platforms.unix;
  };
})
