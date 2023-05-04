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
, libXrandr
, fmt_8
, nlohmann_json
}:

stdenv.mkDerivation rec {
  pname = "giada";
  version = "unstable-2023-05-02";

  src = fetchFromGitHub {
    owner = "monocasual";
    repo = pname;
    # Using master with https://github.com/monocasual/giada/pull/509 till a new release is done.
    rev = "9bffd0976daa3e73c9c7199d0051cb8518dbab7a";
    sha256 = "sha256-LatkdqVGRCslaxrwZfZDmzYlqZx/8/3DwdnmLX0cdI4=";
    fetchSubmodules = true;
  };

  env.NIX_CFLAGS_COMPILE = toString [
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
    fmt_8
    nlohmann_json
    libXrandr
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
