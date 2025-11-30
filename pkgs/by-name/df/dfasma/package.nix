{
  stdenv,
  lib,
  fetchFromGitHub,
  fftw,
  libsndfile,
  libsForQt5,
}:

let

  reaperFork = {
    src = fetchFromGitHub {
      sha256 = "07m2wf2gqyya95b65gawrnr4pvc9jyzmg6h8sinzgxlpskz93wwc";
      rev = "39053e8896eedd7b3e8a9e9a9ffd80f1fc6ceb16";
      repo = "REAPER";
      owner = "gillesdegottex";
    };
    meta = with lib; {
      license = licenses.asl20;
    };
  };

  libqaudioextra = {
    src = fetchFromGitHub {
      sha256 = "0m6x1qm7lbjplqasr2jhnd2ndi0y6z9ybbiiixnlwfm23sp15wci";
      rev = "9ae051989a8fed0b2f8194b1501151909a821a89";
      repo = "libqaudioextra";
      owner = "gillesdegottex";
    };
    meta = with lib; {
      license = licenses.gpl3Plus;
    };
  };

in
stdenv.mkDerivation (finalAttrs: {
  pname = "dfasma";
  version = "1.4.5";

  src = fetchFromGitHub {
    sha256 = "09fcyjm0hg3y51fnjax88m93im39nbynxj79ffdknsazmqw9ac0h";
    tag = "v${finalAttrs.version}";
    repo = "dfasma";
    owner = "gillesdegottex";
  };

  buildInputs = [
    fftw
    libsndfile
    libsForQt5.qtbase
    libsForQt5.qtmultimedia
  ];

  nativeBuildInputs = [
    libsForQt5.qmake
    libsForQt5.wrapQtAppsHook
  ];

  postPatch = ''
    cp -Rv "${reaperFork.src}"/* external/REAPER
    cp -Rv "${libqaudioextra.src}"/* external/libqaudioextra
    substituteInPlace dfasma.pro --replace "CONFIG += file_sdif" "";
  '';

  meta = {
    description = "Analyse and compare audio files in time and frequency";
    mainProgram = "dfasma";
    longDescription = ''
      DFasma is free open-source software to compare audio files by time and
      frequency. The comparison is first visual, using wavforms and spectra. It
      is also possible to listen to time-frequency segments in order to allow
      perceptual comparison. It is basically dedicated to analysis. Even though
      there are basic functionalities to align the signals in time and
      amplitude, this software does not aim to be an audio editor.
    '';
    homepage = "https://gillesdegottex.gitlab.io/dfasma-website/";
    license = [
      lib.licenses.gpl3Plus
      reaperFork.meta.license
    ];
    platforms = lib.platforms.linux;
  };
})
