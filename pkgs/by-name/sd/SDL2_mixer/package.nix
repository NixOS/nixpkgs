{
  lib,
  SDL2,
  darwin,
  fetchFromGitHub,
  flac,
  fluidsynth,
  libmodplug,
  libogg,
  libvorbis,
  mpg123,
  opusfile,
  pkg-config,
  smpeg2,
  stdenv,
  timidity,
  # Boolean flags
  enableSdltest ? (!stdenv.hostPlatform.isDarwin),
  enableSmpegtest ? (!stdenv.hostPlatform.isDarwin),
}:

let
  inherit (darwin.apple_sdk.frameworks) CoreServices AudioUnit AudioToolbox;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "SDL2_mixer";
  version = "2.8.0";

  src = fetchFromGitHub {
    owner = "libsdl-org";
    repo = "SDL_mixer";
    rev = "release-${finalAttrs.version}";
    hash = "sha256-jLKawxnwP5dJglUhgHfWgmKh27i32Rr4LcJQdpXasco=";
  };

  nativeBuildInputs = [
    SDL2
    pkg-config
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
    AudioToolbox
    AudioUnit
    CoreServices
  ];

  propagatedBuildInputs = [
    SDL2
    flac
    fluidsynth
    libmodplug
    libogg
    libvorbis
    mpg123
    opusfile
    smpeg2
    # MIDI patterns
    timidity
  ];

  outputs = [
    "out"
    "dev"
  ];

  strictDeps = true;

  configureFlags = [
    (lib.enableFeature false "music-ogg-shared")
    (lib.enableFeature false "music-flac-shared")
    (lib.enableFeature false "music-mod-modplug-shared")
    (lib.enableFeature false "music-mp3-mpg123-shared")
    (lib.enableFeature false "music-opus-shared")
    (lib.enableFeature false "music-midi-fluidsynth-shared")
    (lib.enableFeature enableSdltest "sdltest")
    (lib.enableFeature enableSmpegtest "smpegtest")
    # override default path to allow MIDI files to be played
    (lib.withFeatureAs true "timidity-cfg" "${timidity}/share/timidity/timidity.cfg")
  ];

  meta = {
    homepage = "https://github.com/libsdl-org/SDL_mixer";
    description = "SDL multi-channel audio mixer library";
    license = lib.licenses.zlib;
    maintainers = lib.teams.sdl.members ++ (with lib.maintainers; [ ]);
    platforms = lib.platforms.unix;
  };
})
