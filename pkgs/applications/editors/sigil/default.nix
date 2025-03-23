{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  makeWrapper,
  boost,
  xercesc,
  qtbase,
  qttools,
  qtwebengine,
  qtsvg,
  python3Packages,
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
    makeWrapper
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

  dontWrapQtApps = true;

  preFixup = ''
    wrapProgram "$out/bin/sigil" \
       --prefix PYTHONPATH : $PYTHONPATH \
       ''${qtWrapperArgs[@]}
  '';

  meta = {
    description = "Free, open source, multi-platform ebook (ePub) editor";
    homepage = "https://github.com/Sigil-Ebook/Sigil/";
    license = lib.licenses.gpl3;
    # currently unmaintained
    platforms = lib.platforms.linux;
    mainProgram = "sigil";
  };
}
