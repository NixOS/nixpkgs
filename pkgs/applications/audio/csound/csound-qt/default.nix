{
  lib,
  stdenv,
  csound,
  desktop-file-utils,
  fetchFromGitHub,
  python3,
  python-qt,
  qmake,
  qtwebengine,
  qtxmlpatterns,
  rtmidi,
  wrapQtAppsHook,
}:

stdenv.mkDerivation rec {
  pname = "csound-qt";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "CsoundQt";
    repo = "CsoundQt";
    rev = "v${version}";
    hash = "sha256-PdylVOnunbB36dbZX/wzd9A8CJPDv/xH5HPLAUkRu28=";
  };

  patches = [
    ./rtmidipath.patch
  ];

  nativeBuildInputs = [
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

  meta = with lib; {
    description = "CsoundQt is a frontend for Csound with editor, integrated help, widgets and other features";
    homepage = "https://csoundqt.github.io/";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ hlolli ];
  };
}
