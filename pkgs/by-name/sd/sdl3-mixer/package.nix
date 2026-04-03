{
  lib,
  stdenv,
  fetchurl,
  cmake,
  ninja,
  pkg-config,
  validatePkgConfig,
  nix-update-script,
  testers,
  sdl3,
  flac,
  fluidsynth,
  game-music-emu,
  libogg,
  libsndfile,
  libvorbis,
  libxmp,
  mpg123,
  opusfile,
  timidity,
  wavpack,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "sdl3-mixer";
  version = "3.2.0";

  outputs = [
    "lib"
    "dev"
    "out"
  ];

  src = fetchurl {
    url = "https://github.com/libsdl-org/SDL_mixer/releases/download/release-${finalAttrs.version}/SDL3_mixer-${finalAttrs.version}.tar.gz";
    hash = "sha256-H4b65yJtWPKtIQyk2eBkiNtyIjADKANCPYO61tNfw5U=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
    validatePkgConfig
  ];

  buildInputs = [
    sdl3
    flac
    fluidsynth
    game-music-emu
    libogg
    libsndfile
    libvorbis
    libxmp
    mpg123
    opusfile
    timidity
    wavpack
  ];

  # Prefer the packaged timidity config instead of relying on host /etc paths.
  postPatch = ''
    substituteInPlace src/decoder_timidity.c \
      --replace-fail '"/etc/timidity.cfg"' '"${timidity}/share/timidity/timidity.cfg"'
  '';

  cmakeFlags = [
    (lib.cmakeBool "SDLMIXER_STRICT" true)
    (lib.cmakeBool "SDLMIXER_VENDORED" false)
    (lib.cmakeBool "SDLMIXER_DEPS_SHARED" false)
    (lib.cmakeBool "SDLMIXER_TESTS" false)
    (lib.cmakeBool "SDLMIXER_EXAMPLES" false)

    # Prefer system codec libraries over built-in single-header decoders.
    (lib.cmakeBool "SDLMIXER_FLAC_LIBFLAC" true)
    (lib.cmakeBool "SDLMIXER_FLAC_DRFLAC" false)
    (lib.cmakeBool "SDLMIXER_MP3_MPG123" true)
    (lib.cmakeBool "SDLMIXER_MP3_DRMP3" false)
    (lib.cmakeBool "SDLMIXER_VORBIS_VORBISFILE" true)
    (lib.cmakeBool "SDLMIXER_VORBIS_STB" false)

    (lib.cmakeBool "SDLMIXER_OPUS" true)
    (lib.cmakeBool "SDLMIXER_GME" true)
    (lib.cmakeBool "SDLMIXER_MOD_XMP" true)
    (lib.cmakeBool "SDLMIXER_WAVPACK" true)
    (lib.cmakeBool "SDLMIXER_MIDI_FLUIDSYNTH" true)
    (lib.cmakeBool "SDLMIXER_MIDI_TIMIDITY" true)
  ];

  passthru = {
    updateScript = nix-update-script {
      extraArgs = [
        "--version-regex"
        "release-(3\\..*)"
      ];
    };
    tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
  };

  meta = {
    description = "SDL audio mixer library for SDL3";
    homepage = "https://github.com/libsdl-org/SDL_mixer";
    changelog = "https://github.com/libsdl-org/SDL_mixer/releases/tag/release-${finalAttrs.version}";
    license = lib.licenses.zlib;
    teams = [ lib.teams.sdl ];
    inherit (sdl3.meta) platforms;
    pkgConfigModules = [ "sdl3-mixer" ];
  };
})
