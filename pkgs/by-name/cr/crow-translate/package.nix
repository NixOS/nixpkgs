{
  lib,
  stdenv,
  fetchFromGitLab,
  cmake,
  extra-cmake-modules,
  leptonica,
  qt6,
  tesseract,
  testers,
  kdePackages,
  onnxruntime,
  withPiper ? true,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "crow-translate";
  version = "4.0.2";

  src = fetchFromGitLab {
    domain = "invent.kde.org";
    owner = "office";
    repo = "crow-translate";
    tag = "v${finalAttrs.version}";
    hash = "sha256-hrxYC6zdh4aG9AkHZcnOE5jihJSo3xrq0hzBRE8NtRw=";
    fetchSubmodules = true;
  };

  postPatch = ''
    substituteInPlace data/org.kde.CrowTranslate.desktop.in \
      --subst-var-by QT_BIN_DIR ${lib.getBin qt6.qttools}/bin
  '';

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    qt6.qttools
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    kdePackages.kwayland
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
