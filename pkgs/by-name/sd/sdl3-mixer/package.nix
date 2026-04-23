{
  lib,
  stdenv,
  fetchFromGitHub,
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
  __structuredAttrs = true;

  outputs = [
    "dev"
    "out"
  ];

  src = fetchFromGitHub {
    owner = "libsdl-org";
    repo = "SDL_mixer";
    tag = "release-${finalAttrs.version}";
    hash = "sha256-+kOxmBX/zPCTq51F9ysSGsZdJSb21uM56U50mEgprbo=";
  };

  strictDeps = true;
  doCheck = true;

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
    (lib.cmakeBool "SDLMIXER_DEPS_SHARED" false)
    (lib.cmakeBool "SDLMIXER_TESTS" finalAttrs.finalPackage.doCheck)
    (lib.cmakeBool "SDLMIXER_EXAMPLES" false)

    # Prefer libFLAC for feature parity with other distros and better diagnostics.
    (lib.cmakeBool "SDLMIXER_FLAC_DRFLAC" false)
    # Prefer mpg123: more capable, better maintained.
    # Built-in dr_mp3 may introduce subtle decoding differences; use only as a fallback.
    (lib.cmakeBool "SDLMIXER_MP3_DRMP3" false)
    # Prefer libvorbisfile to keep backend behavior aligned with system libraries.
    (lib.cmakeBool "SDLMIXER_VORBIS_STB" false)
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
    maintainers = with lib.maintainers; [ jujb233 ];
    teams = [ lib.teams.sdl ];
    platforms = lib.platforms.unix;
    pkgConfigModules = [ "sdl3-mixer" ];
  };
})
