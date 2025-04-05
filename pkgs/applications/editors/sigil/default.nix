{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  boost,
  xercesc,
  qtbase,
  qttools,
  qtwebengine,
  qtsvg,
  python3Packages,
  wrapQtAppsHook,
}:

stdenv.mkDerivation rec {
  pname = "sigil";
  version = "2.4.2";

  src = fetchFromGitHub {
    repo = "Sigil";
    owner = "Sigil-Ebook";
    tag = version;
    hash = "sha256-/lnSNamLkPLG8tn0w8F0zFyypMUXyMhgxA2WyQFegKw=";
  };

  pythonPath = with python3Packages; [ lxml ];

  nativeBuildInputs = [
    cmake
    pkg-config
    wrapQtAppsHook
  ];

  buildInputs = [
    boost
    xercesc
    qtbase
    qttools
    qtwebengine
    qtsvg
    python3Packages.lxml
  ];

  prePatch = ''
    sed -i '/^QTLIB_DIR=/ d' src/Resource_Files/bash/sigil-sh_install
  '';

  preFixup = ''
    qtWrapperArgs+=(--prefix PYTHONPATH : "$PYTHONPATH")
  '';

  meta = {
    description = "Free, open source, multi-platform ebook (ePub) editor";
    homepage = "https://github.com/Sigil-Ebook/Sigil/";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ prince213 ];
    platforms = lib.platforms.linux;
    mainProgram = "sigil";
  };
}
