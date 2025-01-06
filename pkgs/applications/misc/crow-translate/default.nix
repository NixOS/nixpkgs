{ lib
, stdenv
, fetchFromGitLab
, cmake
, extra-cmake-modules
, qttools
, kwayland
, leptonica
, tesseract4
, qtmultimedia
, qtx11extras
, wrapQtAppsHook
, gst_all_1
, testers
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "crow-translate";
  version = "3.0.0";

  src = fetchFromGitLab {
    domain = "invent.kde.org";
    owner = "office";
    repo = "crow-translate";
    rev = "v${finalAttrs.version}";
    hash = "sha256-hdrhxbv44DlxoF1JU1d2auP/vR8a3IJI+hN7PhdPMaY=";
    fetchSubmodules = true;
  };

  postPatch = ''
    substituteInPlace data/org.kde.CrowTranslate.desktop.in \
      --subst-var-by QT_BIN_DIR ${lib.getBin qttools}/bin
  '';

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    qttools
    wrapQtAppsHook
  ];

  buildInputs = [
    kwayland
    leptonica
    tesseract4
    qtmultimedia
    qtx11extras
  ] ++ (with gst_all_1; [
    gstreamer
    gst-plugins-base
    gst-plugins-good
    gst-plugins-bad
  ]);

  preFixup = ''
    qtWrapperArgs+=(--prefix GST_PLUGIN_SYSTEM_PATH_1_0 : "$GST_PLUGIN_SYSTEM_PATH_1_0")
  '';

  passthru.tests.version = testers.testVersion {
    package = finalAttrs.finalPackage;
  };

  meta = {
    description = "Simple and lightweight translator that allows to translate and speak text using Google, Yandex and Bing";
    homepage = "https://invent.kde.org/office/crow-translate";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ sikmir ];
    platforms = lib.platforms.linux;
    mainProgram = "crow";
  };
})
