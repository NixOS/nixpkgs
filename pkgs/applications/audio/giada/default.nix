{ lib
, stdenv
, fetchFromGitHub
<<<<<<< HEAD
, fetchpatch
, cmake
, pkg-config
, fltk
, fmt
, rtmidi
, libsamplerate
, libmpg123
=======
, cmake
, pkg-config
, fltk
, rtmidi
, libsamplerate
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, libsndfile
, jack2
, alsa-lib
, libpulseaudio
, libXpm
<<<<<<< HEAD
, libXrandr
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, flac
, libogg
, libvorbis
, libopus
<<<<<<< HEAD
, nlohmann_json
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

stdenv.mkDerivation rec {
  pname = "giada";
<<<<<<< HEAD
  version = "0.25.1";
=======
  version = "unstable-2021-09-24";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "monocasual";
    repo = pname;
<<<<<<< HEAD
    rev = version;
    sha256 = "sha256-SW2qT+pMKTMBnkaL+Dg87tqutcLTqaY4nCeFfJjHIw4=";
=======
    # Using master with https://github.com/monocasual/giada/pull/509 till a new release is done.
    rev = "f117a8b8eef08d904ef1ab22c45f0e1fad6b8a56";
    sha256 = "01hb981lrsyk870zs8xph5fm0z7bbffpkxgw04hq487r804mkx9j";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
    rtmidi
    fltk
<<<<<<< HEAD
    fmt
    libmpg123
    libsndfile
    libsamplerate
    nlohmann_json
=======
    libsndfile
    libsamplerate
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    alsa-lib
    libXpm
    libpulseaudio
    jack2
    flac
    libogg
    libvorbis
    libopus
<<<<<<< HEAD
    libXrandr
  ];

=======
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

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  meta = with lib; {
    description = "A free, minimal, hardcore audio tool for DJs, live performers and electronic musicians";
    homepage = "https://giadamusic.com/";
    license = licenses.gpl3;
<<<<<<< HEAD
    maintainers = with maintainers; [ kashw2 ];
=======
    maintainers = with maintainers; [ ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    platforms = platforms.all;
  };
}
