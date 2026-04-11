{
  lib,
  stdenv,
  fetchFromGitHub,
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
  version = "1.10.3";

  src = fetchFromGitHub {
    owner = "bbc";
    repo = "audiowaveform";
    tag = version;
    sha256 = "sha256-7pcYxl6m7mkoXGawA3gr8NTfkJlkgl+DtK79CA8dRec=";
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
    homepage = "https://github.com/bbc/audiowaveform";
    changelog = "https://github.com/bbc/audiowaveform/blob/${version}/ChangeLog";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ edbentley ];
    mainProgram = "audiowaveform";
  };
}
