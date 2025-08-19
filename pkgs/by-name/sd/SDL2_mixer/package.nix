{
  lib,
  SDL2,
  fetchFromGitHub,
  flac,
  fluidsynth,
  libogg,
  libvorbis,
  mpg123,
  opusfile,
  pkg-config,
  smpeg2,
  stdenv,
  timidity,
  wavpack,
  libxmp,
  game-music-emu,
  # Boolean flags
  enableSdltest ? (!stdenv.hostPlatform.isDarwin),
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "SDL2_mixer";
  version = "2.8.1";

  src = fetchFromGitHub {
    owner = "libsdl-org";
    repo = "SDL_mixer";
    rev = "release-${finalAttrs.version}";
    hash = "sha256-6HOTLwGi2oSQChwHE/oNHfZpcMh8xTuwNQSpKS01bwI=";
  };

  nativeBuildInputs = [
    SDL2
    pkg-config
  ];

  propagatedBuildInputs = [
    SDL2
    flac
    fluidsynth
    libogg
    libvorbis
    mpg123
    opusfile
    smpeg2
    wavpack
    libxmp
    game-music-emu
    # MIDI patterns
    timidity
  ];

  outputs = [
    "out"
    "dev"
  ];

  strictDeps = true;

  configureFlags = [
    (lib.enableFeature false "music-mod-modplug-shared")
    (lib.enableFeature false "music-mp3-mpg123-shared")
    (lib.enableFeature false "music-opus-shared")
    (lib.enableFeature false "music-midi-fluidsynth-shared")
    (lib.enableFeature enableSdltest "sdltest")
    # override default path to allow MIDI files to be played
    (lib.withFeatureAs true "timidity-cfg" "${timidity}/share/timidity/timidity.cfg")
  ];

  meta = {
    homepage = "https://github.com/libsdl-org/SDL_mixer";
    description = "SDL multi-channel audio mixer library";
    license = lib.licenses.zlib;
    teams = [ lib.teams.sdl ];
    platforms = lib.platforms.unix;
  };
})
