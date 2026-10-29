{
  lib,
  stdenv,
  fetchFromGitHub,

  cmake,
  pkg-config,

  bluez,
  libnotify,
  opencv,
  qt6,

  # Running with TTS support causes the program to freeze for a few seconds every time at startup,
  # so it is disabled by default
  textToSpeechSupport ? false,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "actiona";
  version = "3.11.1";

  src = fetchFromGitHub {
    owner = "Jmgr";
    repo = "actiona";
    tag = "v${finalAttrs.version}";
    hash = "sha256-sJlzrrpmo2CbzChCtiyxqDtjoN58BN4Ptjm4sH83zAw=";
    fetchSubmodules = true;
  };

  patches = [
    # Meet Qt 6.10 requirement for explicit find_package of private targets
    ./fix-qt6-10-private-targets.diff
  ]
  ++ lib.optionals (!textToSpeechSupport) [
    # Removes TTS support
    ./disable-tts.patch
  ];

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    pkg-config
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    bluez
    libnotify
    # NOTE: Specifically not using lib.getOutput here because it would select the out output of opencv, which changes
    # semantics since make-derivation uses lib.getDev on the dependency arrays, which won't touch derivations with
    # specified outputs.
    (opencv.cxxdev or opencv)
    qt6.qtbase
    qt6.qtmultimedia
    qt6.qttools
    qt6.qt5compat
  ]
  ++ lib.optionals textToSpeechSupport [ qt6.qtspeech ];

  meta = {
    description = "Cross-platform automation tool";
    homepage = "https://github.com/Jmgr/actiona";
    license = lib.licenses.gpl3Only;
    mainProgram = "actiona";
    maintainers = with lib.maintainers; [ tomasajt ];
    platforms = lib.platforms.linux;
  };
})
