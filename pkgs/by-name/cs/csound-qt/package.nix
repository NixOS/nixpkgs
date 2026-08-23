{
  lib,
  stdenv,
  csound,
  desktop-file-utils,
  fetchFromGitHub,
  python3,
  rtmidi,
  qt6,
  alsa-lib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "csound-qt";
  version = "7.0.0-beta1";

  src = fetchFromGitHub {
    owner = "CsoundQt";
    repo = "CsoundQt";
    tag = "v${finalAttrs.version}";
    hash = "sha256-R/rGbLVJBjMimne3yDoPJKwrXyRqhfepV3g0Uaj/dbY=";
  };

  patches = [
    ./rtmidipath.patch
  ];

  nativeBuildInputs = with qt6; [
    qmake
    qtwebengine
    qtdeclarative
    wrapQtAppsHook
  ];

  buildInputs = [
    alsa-lib
    csound
    desktop-file-utils
    rtmidi
  ];

  qmakeFlags = [
    "qcs.pro"
    "CONFIG+=rtmidi"
    "CONFIG+=record_support"
    "CONFIG+=html_webengine"
    "CSOUND_INCLUDE_DIR=${csound}/include/csound"
    "CSOUND_LIBRARY_DIR=${csound}/lib"
    "RTMIDI_DIR=${rtmidi.src}"
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
