{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  freetype,
  fluidsynth,
  SDL,
  SDL_gfx,
  SDL_ttf,
  liblo,
  libxml2,
  alsa-lib,
  libjack2,
  libvorbis,
  libSM,
  libsndfile,
  libogg,
  libX11,
  nettle,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "freewheeling";
  version = "0.6.6";

  src = fetchFromGitHub {
    owner = "free-wheeling";
    repo = "freewheeling";
    tag = "v${finalAttrs.version}";
    hash = "sha256-xEZBE/7nUvK2hruqP6QQzlsIDmuniPZg7JEJkCEvzvU=";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    freetype
    fluidsynth
    SDL
    SDL_gfx
    SDL_ttf
    liblo
    libxml2
    libjack2
    alsa-lib
    libvorbis
    libsndfile
    libogg
    libSM
    libX11
    nettle
  ];

  env.NIX_CFLAGS_COMPILE = "-I${lib.getDev libxml2}/include/libxml2";

  meta = {
    description = "Live looping instrument with JACK and MIDI support";
    longDescription = ''
      Freewheeling allows us to build repetitive grooves
      by sampling and directing loops from within spirited improvisation.

      It works because, down to the core, it's built around
      improv. We leave mice and menus, and dive into our own process
      of making sound.

      Freewheeling runs under macOS and Linux, and is open source
      software, released under the GNU GPL license.
    '';

    homepage = "https://freewheeling.sourceforge.net";
    license = lib.licenses.gpl2;
    maintainers = [ lib.maintainers.sepi ];
    platforms = lib.platforms.linux;
    mainProgram = "fweelin";
  };
})
