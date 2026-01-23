{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
  nix-update-script,
  asciidoctor,
  cmake,
  doxygen,
  pkg-config,
  flac,
  fluidsynth,
  fmt,
  freetype,
  glib,
  harfbuzz,
  lhasa,
  liblcf,
  libpng,
  libsndfile,
  libsysprof-capture,
  libvorbis,
  libxmp,
  mpg123,
  nlohmann_json,
  opusfile,
  pcre2,
  pixman,
  speexdsp,
  wildmidi,
}:
mkLibretroCore rec {
  core = "easyrpg";
  # liblcf needs to be updated before this.
  version = "0.8.1.1";

  src = fetchFromGitHub {
    owner = "EasyRPG";
    repo = "Player";
    rev = version;
    hash = "sha256-2a8IdYP6Suc8a+Np5G+xoNzuPxkk9gAgR+sjdKUf89M=";
    fetchSubmodules = true;
  };

  extraNativeBuildInputs = [
    asciidoctor
    cmake
    doxygen
    pkg-config
  ];
  extraBuildInputs = [
    flac # needed by libsndfile
    fluidsynth
    fmt
    freetype
    glib
    harfbuzz
    lhasa
    liblcf
    libpng
    libsndfile
    libsysprof-capture # needed by glib
    libvorbis
    libxmp
    mpg123
    nlohmann_json
    opusfile
    pcre2 # needed by glib
    pixman
    speexdsp
    wildmidi
  ];
  cmakeFlags = [
    "-DBUILD_SHARED_LIBS=ON"
    "-DPLAYER_TARGET_PLATFORM=libretro"
    "-DCMAKE_INSTALL_DATADIR=${placeholder "out"}/share"
  ];
  makefile = "Makefile";

  # Since liblcf needs to be updated before this, we should not
  # use the default unstableGitUpdater.
  passthru.updateScript = nix-update-script { };

  meta = {
    description = "EasyRPG Player libretro port";
    homepage = "https://github.com/EasyRPG/Player";
    license = lib.licenses.gpl3Plus;
  };
}
