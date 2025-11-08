{
  lib,
  stdenv,
  csound,
  desktop-file-utils,
  fetchFromGitHub,
  python3,
  python-qt,
  rtmidi,
  libsForQt5,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "csound-qt";
  version = "1.1.3";

  src = fetchFromGitHub {
    owner = "CsoundQt";
    repo = "CsoundQt";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ZdQwWRAr6AKLmZ/L0lSxIlvWRLoZIKinn7BAQiR+luk=";
  };

  patches = [
    ./rtmidipath.patch
  ];

  nativeBuildInputs = with libsForQt5; [
    qmake
    qtwebengine
    qtxmlpatterns
    wrapQtAppsHook
  ];

  buildInputs = [
    csound
    desktop-file-utils
    rtmidi
  ];

  qmakeFlags = [
    "qcs.pro"
    "CONFIG+=rtmidi"
    "CONFIG+=pythonqt"
    "CONFIG+=record_support"
    "CONFIG+=html_webengine"
    "CSOUND_INCLUDE_DIR=${csound}/include/csound"
    "CSOUND_LIBRARY_DIR=${csound}/lib"
    "RTMIDI_DIR=${rtmidi.src}"
    "PYTHONQT_SRC_DIR=${python-qt.src}"
    "PYTHONQT_LIB_DIR=${python-qt}/lib"
    "LIBS+=-L${python-qt}/lib"
    "INSTALL_DIR=${placeholder "out"}"
    "SHARE_DIR=${placeholder "out"}/share"
    "PYTHON_DIR=${python3}"
    "PYTHON_VERSION=3.${python3.sourceVersion.minor}"
  ];

  meta = {
    description = "CsoundQt is a frontend for Csound with editor, integrated help, widgets and other features";
    homepage = "https://csoundqt.github.io/";
    license = lib.licenses.gpl2;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ hlolli ];
  };
})
