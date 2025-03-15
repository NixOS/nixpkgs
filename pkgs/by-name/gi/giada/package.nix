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
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "monocasual";
    repo = "giada";
    tag = finalAttrs.version;
    hash = "sha256-t24S8tmx9VFcpEwe5EzoMQ7xhX8dj92Mq43gaWc+C50=";
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
      rtmidi
      fltk
      fmt
      libmpg123
      libsndfile
      libsamplerate
      nlohmann_json
      alsa-lib
      libXpm
      libpulseaudio
      jack2
      flac
      libogg
      libvorbis
      libopus
      libXrandr
      expat
      libGL
      curl
      webkitgtk_4_1
      gtk3
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
