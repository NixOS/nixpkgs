{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, cmake
, pkg-config
, fltk
, fmt
, rtmidi
, libsamplerate
, libmpg123
, libsndfile
, jack2
, alsa-lib
, libpulseaudio
, libXpm
, libXrandr
, flac
, libogg
, libvorbis
, libopus
, nlohmann_json
}:

stdenv.mkDerivation rec {
  pname = "giada";
  version = "0.25.1";

  src = fetchFromGitHub {
    owner = "monocasual";
    repo = pname;
    rev = version;
    sha256 = "sha256-SW2qT+pMKTMBnkaL+Dg87tqutcLTqaY4nCeFfJjHIw4=";
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

  buildInputs = [
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
  ];

  meta = with lib; {
    description = "A free, minimal, hardcore audio tool for DJs, live performers and electronic musicians";
    homepage = "https://giadamusic.com/";
    license = licenses.gpl3;
    maintainers = with maintainers; [ kashw2 ];
    platforms = platforms.all;
  };
}
