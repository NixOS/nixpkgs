{ lib
, stdenv
, fetchFromGitHub
, cmake
, pkg-config
, fltk
, rtmidi
, libsamplerate
, libsndfile
, jack2
, alsa-lib
, libpulseaudio
, libXpm
, flac
, libogg
, libvorbis
, libopus
}:

stdenv.mkDerivation rec {
  pname = "giada";
  version = "unstable-2021-09-24";

  src = fetchFromGitHub {
    owner = "monocasual";
    repo = pname;
    # Using master with https://github.com/monocasual/giada/pull/509 till a new release is done.
    rev = "f117a8b8eef08d904ef1ab22c45f0e1fad6b8a56";
    sha256 = "01hb981lrsyk870zs8xph5fm0z7bbffpkxgw04hq487r804mkx9j";
    fetchSubmodules = true;
  };

  NIX_CFLAGS_COMPILE = [
    "-w"
    "-Wno-error"
  ];

  cmakeFlags = [
    "-DCMAKE_INSTALL_BINDIR=bin"
    "-DCMAKE_BUILD_TYPE=Release"
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    rtmidi
    fltk
    libsndfile
    libsamplerate
    alsa-lib
    libXpm
    libpulseaudio
    jack2
    flac
    libogg
    libvorbis
    libopus
  ];

  postPatch = ''
    local fixup_list=(
      src/core/kernelMidi.cpp
      src/gui/elems/config/tabMidi.cpp
      src/utils/ver.cpp
    )
    for f in "''${fixup_list[@]}"; do
      substituteInPlace "$f" \
        --replace "<RtMidi.h>" "<${rtmidi.src}/RtMidi.h>"
    done
  '';

  meta = with lib; {
    description = "A free, minimal, hardcore audio tool for DJs, live performers and electronic musicians";
    homepage = "https://giadamusic.com/";
    license = licenses.gpl3;
    maintainers = with maintainers; [ ];
    platforms = platforms.all;
  };
}
