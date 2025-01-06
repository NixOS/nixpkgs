{
  lib,
  mkDerivation,
  fetchFromGitHub,
  cmake,
  pkg-config,
  makeWrapper,
  boost,
  xercesc,
  qtbase,
  qttools,
  qtwebengine,
  qtxmlpatterns,
  python3Packages,
}:

mkDerivation rec {
  pname = "sigil";
  version = "2.0.1";

  src = fetchFromGitHub {
    repo = "Sigil";
    owner = "Sigil-Ebook";
    rev = version;
    sha256 = "sha256-d54N6Kb+xLMxlRwqxqWXnFGQCvUmSy9z6j86aV+VioU=";
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
    qtxmlpatterns
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
