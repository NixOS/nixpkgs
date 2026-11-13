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
  versionCheckHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "audiowaveform";
  version = "1.11.1";

  src = fetchFromCodeberg {
    owner = "chrisn";
    repo = "audiowaveform";
    tag = finalAttrs.version;
    hash = "sha256-n5J7TzA3uRXUzqYR2lGNzHkWeFH2SkghqWMBKWARHzo=";
  };

  __structuredAttrs = true;
  strictDeps = true;

  cmakeFlags = [
    # Upstream hardcodes -std=c++11; vendored gtest >= 1.17 requires C++17.
    (lib.cmakeFeature "CMAKE_CXX_STANDARD" "17")
  ];

  nativeBuildInputs = [ cmake ];

  buildInputs = [
    boost
    gd
    libsndfile
    libmad
    libid3tag
  ];

  # Upstream builds googletest from source via add_subdirectory(googletest).
  postUnpack = ''
    cp -r ${gtest.src} "$sourceRoot/googletest"
    chmod -R u+w "$sourceRoot/googletest"
  '';

  doCheck = true;

  # One test is failing, see https://codeberg.org/chrisn/audiowaveform/issues/174
  env.GTEST_FILTER = "-OptionHandlerTest.shouldConvertMp3ToWavAudio";

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  meta = {
    description = "C++ program to generate waveform data and render waveform images from audio files";
    longDescription = ''
      audiowaveform is a C++ command-line application that generates waveform data from either MP3, WAV, FLAC, or Ogg Vorbis format audio files.
      Waveform data can be used to produce a visual rendering of the audio, similar in appearance to audio editing applications.
    '';
    homepage = "https://codeberg.org/chrisn/audiowaveform";
    changelog = "https://codeberg.org/chrisn/audiowaveform/src/tag/${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ edbentley ];
    mainProgram = "audiowaveform";
  };
})
