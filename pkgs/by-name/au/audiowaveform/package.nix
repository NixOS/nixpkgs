{
  lib,
  stdenv,
  fetchFromCodeberg,
  cmake,
  gtest,
  boost,
  gd,
  libsndfile,
  libmad,
  libid3tag,
}:

stdenv.mkDerivation rec {
  pname = "audiowaveform";
  version = "1.11.1";

  src = fetchFromCodeberg {
    owner = "chrisn";
    repo = "audiowaveform";
    tag = version;
    sha256 = "sha256-n5J7TzA3uRXUzqYR2lGNzHkWeFH2SkghqWMBKWARHzo=";
  };

  cmakeFlags = [
    # gtest no longer supports C++11.
    "-DCMAKE_CXX_STANDARD=14"
  ];

  nativeBuildInputs = [
    cmake
    gtest
  ];

  buildInputs = [
    boost
    gd
    libsndfile
    libmad
    libid3tag
  ];

  preConfigure = ''
    ln -s ${gtest.src} googletest
  '';

  # One test is failing, see PR #101947
  doCheck = false;

  meta = {
    description = "C++ program to generate waveform data and render waveform images from audio files";
    longDescription = ''
      audiowaveform is a C++ command-line application that generates waveform data from either MP3, WAV, FLAC, or Ogg Vorbis format audio files.
      Waveform data can be used to produce a visual rendering of the audio, similar in appearance to audio editing applications.
    '';
    homepage = "https://codeberg.org/chrisn/audiowaveform";
    changelog = "https://codeberg.org/chrisn/audiowaveform/src/tag/${version}/CHANGELOG.md";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ edbentley ];
    mainProgram = "audiowaveform";
  };
}
