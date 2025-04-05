{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  boost,
  xercesc,
  python3Packages,
  qt6,
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
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    boost
    xercesc
    qt6.qtbase
    qt6.qttools
    qt6.qtwebengine
    qt6.qtsvg
    python3Packages.lxml
  ];

  prePatch = ''
    sed -i '/^QTLIB_DIR=/ d' src/Resource_Files/bash/sigil-sh_install
  '';

  dontWrapQtApps = true;

  preFixup = ''
    wrapQtApp "$out/bin/sigil" --prefix PYTHONPATH : $PYTHONPATH
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
