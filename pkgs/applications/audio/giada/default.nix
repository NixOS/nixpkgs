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
  version = "0.24.0";

  src = fetchFromGitHub {
    owner = "monocasual";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-pKzc+RRW3o5vYaiGqW9/VjYZZJvr6cg1kdjP9qRkHwM=";
    fetchSubmodules = true;
  };

  patches = [
    # Remove when updating to the next release, this PR is already merged
    # Fix fmt type error: https://github.com/monocasual/giada/pull/635
    (fetchpatch {
      name = "fix-fmt-type-error.patch";
      url = "https://github.com/monocasual/giada/commit/032af4334f6d2bb7e77a49e7aef5b4c4d696df9a.patch";
      hash = "sha256-QuxETvBWzA1v2ifyNzlNMGfQ6XhYQF03sGZA9rBx1xU=";
    })
  ];

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
    maintainers = with maintainers; [ ];
    platforms = platforms.all;
  };
}
