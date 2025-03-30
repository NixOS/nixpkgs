{
  lib,
  stdenv,
  fetchFromGitLab,
  cmake,
  extra-cmake-modules,
  leptonica,
  libsForQt5,
  qt5,
  tesseract4,
  gst_all_1,
  testers,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "crow-translate";
  version = "3.1.0";

  src = fetchFromGitLab {
    domain = "invent.kde.org";
    owner = "office";
    repo = "crow-translate";
    rev = "v${finalAttrs.version}";
    hash = "sha256-zL+Ucw6rzIoEaBHi/uqKQB0cnR6aAcF8MPOG3hwK3iA=";
    fetchSubmodules = true;
  };

  postPatch = ''
    substituteInPlace data/org.kde.CrowTranslate.desktop.in \
      --subst-var-by QT_BIN_DIR ${lib.getBin qt5.qttools}/bin
  '';

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    qt5.qttools
    qt5.wrapQtAppsHook
  ];

  buildInputs =
    [
      libsForQt5.kwayland
      leptonica
      tesseract4
      qt5.qtmultimedia
      qt5.qtx11extras
    ]
    ++ (with gst_all_1; [
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
