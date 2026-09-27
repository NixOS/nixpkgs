{
  lib,
  stdenv,
  fetchFromGitLab,
  cmake,
  espeak-ng,
  leptonica,
  pkg-config,
  qt6,
  tesseract,
  testers,
  kdePackages,
  onnxruntime,
  withPiper ? true,
  withTts ? true,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "crow-translate";
  version = "4.1.0";

  src = fetchFromGitLab {
    domain = "invent.kde.org";
    owner = "office";
    repo = "crow-translate";
    tag = "v${finalAttrs.version}";
    hash = "sha256-A7B/NneWCKLy2BWPOTSXr9CIbSHkL3xih9QMwmEPG34=";
    fetchSubmodules = true;
  };

  postPatch = ''
    substituteInPlace data/org.kde.CrowTranslate.desktop.in \
      --subst-var-by QT_BIN_DIR ${lib.getBin qt6.qttools}/bin
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
    kdePackages.extra-cmake-modules
    qt6.qttools
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    kdePackages.kiconthemes
    kdePackages.kwayland
    espeak-ng
    leptonica
    tesseract
    qt6.qtbase
    qt6.qtmultimedia
    qt6.qtscxml
    qt6.qtspeech
  ]
  ++ lib.optionals withPiper [
    onnxruntime
  ];
  cmakeFlags = [
    (lib.cmakeBool "ONNXRuntime_USE_STATIC" false)
    (lib.cmakeBool "WITH_PIPER_TTS" withPiper)
    (lib.cmakeBool "WITH_TTS" withTts)
    (lib.cmakeBool "ESPEAKNG_USE_SYSTEM" true)
  ];
  # Necessary for KWin D-BUS authorization for taking screenshots, without
  # which the app falls back to interactive capture, which has some limitations.
  postInstall = ''
    substituteInPlace $out/share/applications/org.kde.CrowTranslate.desktop \
      --replace-fail 'Exec=crow' "Exec=$out/bin/crow"
  '';

  passthru.tests.version = testers.testVersion { package = finalAttrs.finalPackage; };

  meta = {
    description = "Simple and lightweight translator that allows to translate and speak text using Google, Yandex and Bing";
    homepage = "https://invent.kde.org/office/crow-translate";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ sikmir ];
    platforms = lib.platforms.linux;
    mainProgram = "crow";
  };
})
