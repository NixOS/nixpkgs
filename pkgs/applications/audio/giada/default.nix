{ lib
, stdenv
, fetchFromGitHub
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
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "monocasual";
    repo = pname;
    rev = version;
    sha256 = "sha256-vTOUS9mI4B3yRNnM2dNCH7jgMuD3ztdhe1FMgXUIt58=";
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
    description = "Free, minimal, hardcore audio tool for DJs, live performers and electronic musicians";
    mainProgram = "giada";
    homepage = "https://giadamusic.com/";
    license = licenses.gpl3;
    maintainers = with maintainers; [ kashw2 ];
    platforms = platforms.all;
  };
}
