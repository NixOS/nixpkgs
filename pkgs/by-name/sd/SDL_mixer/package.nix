{
  lib,
  SDL,
  fetchFromGitHub,
  fluidsynth,
  libopenmpt-modplug,
  libogg,
  libvorbis,
  pkg-config,
  libmpg123,
  flac,
  autoreconfHook,
  stdenv,
  unstableGitUpdater,
  # passthru.tests
  onscripter,
  testers,
  # Boolean flags
  enableSdltest ? (!stdenv.hostPlatform.isDarwin),
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "SDL_mixer";
  version = "1.2.12-unstable-2026-05-11";

  # word of caution: while there is a somewhat maintained SDL-1.2 branch on
  # https://github.com/libsdl-org/SDL_mixer, it switches from smpeg to mpg123 which
  # breaks autoconf in a bunch of packages.
  # smpeg is increasingly showing its age, which is why we no longer wish to depend on it.
  src = fetchFromGitHub {
    owner = "libsdl-org";
    repo = "SDL_mixer";
    rev = "50517740a3916e5ffd719c053c6e7b65f933e23a";
    hash = "sha256-VQywKO2aaZKTAzseWsb0nywLfpS9NHxCCanNTmUsUcs=";
  };

  nativeBuildInputs = [
    pkg-config
    # upstream configure is pre-built expecting FHS compliance:
    # ./configure: line 5346: /usr/bin/file: No such file or directory
    autoreconfHook
    SDL # for sdl.m4
  ];

  buildInputs = [
    SDL
    fluidsynth
    libopenmpt-modplug
    libogg
    libvorbis
    libmpg123
    flac
  ];

  configureFlags = [
    (lib.enableFeature false "music-ogg-shared")
    (lib.enableFeature false "music-mod-shared")
    (lib.enableFeature true "music-mod-modplug")
    (lib.enableFeature enableSdltest "sdltest")
  ];

  outputs = [
    "out"
    "dev"
  ];

  strictDeps = true;
  __structuredAttrs = true;

  passthru.tests = {
    inherit onscripter;
    pkg-config = testers.hasPkgConfigModules { package = finalAttrs.finalPackage; };
  };

  passthru.updateScript = unstableGitUpdater {
    tagFormat = "release-1.*";
    tagPrefix = "release-";
    branch = "SDL-1.2";
  };

  meta = {
    description = "SDL multi-channel audio mixer library";
    homepage = "http://www.libsdl.org/projects/SDL_mixer/";
    pkgConfigModules = [ "SDL_mixer" ];
    teams = [ lib.teams.sdl ];
    license = lib.licenses.zlib;
    inherit (SDL.meta) platforms;
  };
})
