{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
  alsa-lib,
  cmake,
  flac,
  libogg,
  libopus,
  libsndfile,
  libvorbis,
  mpg123,
  ninja,
  opusfile,
  pkg-config,
  SDL,
  SDL_net,
}:
mkLibretroCore {
  core = "dosbox";
  version = "0-unstable-2026-09-28";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "dosbox-libretro";
    rev = "a563bb5e9753f207d74e9d8c417d793b784fa4be";
    hash = "sha256-Gs1AV1gRBeTsqMCHiQjDRNXQGFPDsjDSuKDooevRydo=";
  };

  # cmake and ninja are only used by Makefile.libretro to build the
  # bundled fluidsynth and munt
  extraNativeBuildInputs = [
    cmake
    ninja
    pkg-config
  ];
  dontUseCmakeConfigure = true;
  dontUseNinjaBuild = true;
  dontUseNinjaInstall = true;
  dontUseNinjaCheck = true;

  extraBuildInputs = [
    alsa-lib
    flac
    libogg
    libopus
    libsndfile
    libvorbis
    mpg123
    opusfile
    SDL
    SDL_net
  ];

  # Use the audio codecs and libsndfile from nixpkgs instead of the bundled copies
  makeFlags = [
    "BUNDLED_AUDIO_CODECS=0"
    "BUNDLED_LIBSNDFILE=0"
  ];

  # Makefile.libretro only asks pkg-config for SDL_net's libs, not its cflags.
  # The bundled static fluidsynth needs libsndfile, which its .pc file only
  # lists in Requires.private, so link it explicitly.
  preBuild = ''
    export CXXFLAGS="$CXXFLAGS $(pkg-config --cflags SDL_net)"
    export LDFLAGS="$LDFLAGS $(pkg-config --libs sndfile)"
    cd libretro
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck

    # make sure every symbol of the core resolves
    if ldd -r $out/lib/retroarch/cores/dosbox_libretro.so 2>&1 | grep 'undefined symbol'; then
      exit 1
    fi

    runHook postInstallCheck
  '';

  meta = {
    description = "Port of DOSBox to libretro";
    homepage = "https://github.com/libretro/dosbox-libretro";
    license = lib.licenses.gpl2Only;
  };
}
