{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  fltk,
  fontconfig,
  fmt,
  rtmidi,
  libsamplerate,
  libmpg123,
  libsndfile,
  jack2,
  alsa-lib,
  libpulseaudio,
  libXpm,
  libXrandr,
  flac,
  libogg,
  libvorbis,
  libopus,
  nlohmann_json,
  expat,
  libGL,
  curl,
  webkitgtk_4_1,
  gtk3,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "giada";
  version = "1.2.1";

  src = fetchFromGitHub {
    owner = "monocasual";
    repo = "giada";
    tag = finalAttrs.version;
    hash = "sha256-mp+6MFwUqV6aa1ACdIlel5VhjWDXf5QzfFu1I6If4aU=";
    fetchSubmodules = true;
  };

  env.NIX_CFLAGS_COMPILE = toString [
    "-w"
    "-Wno-error"
  ];

  cmakeFlags = [
    "-DCMAKE_INSTALL_BINDIR=bin"
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs =
    [
      alsa-lib
      curl
      expat
      flac
      fltk
      fmt
      gtk3
      jack2
      libGL
      libXpm
      libXrandr
      libogg
      libopus
      libpulseaudio
      libsamplerate
      libsndfile
      libvorbis
      libmpg123
      nlohmann_json
      rtmidi
      webkitgtk_4_1
    ]
    ++ lib.optionals (stdenv.hostPlatform.isLinux || stdenv.hostPlatform.isFreeBSD) [
      fontconfig
    ];

  meta = {
    description = "Free, minimal, hardcore audio tool for DJs, live performers and electronic musicians";
    mainProgram = "giada";
    homepage = "https://giadamusic.com/";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ kashw2 ];
    platforms = lib.platforms.all;
  };
})
