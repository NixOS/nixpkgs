{ stdenv, lib, fetchFromGitHub, cmake, qtbase, qttools, qtsvg, qt5compat, quazip
, hunspell
, wrapQtAppsHook, poppler, zlib, pkg-config }:

stdenv.mkDerivation (finalAttrs: {
  pname = "texstudio";
  version = "4.6.3";

  src = fetchFromGitHub {
    owner = "texstudio-org";
    repo = "texstudio";
    rev = finalAttrs.version;
    hash = "sha256-L8N7T7FFfjT801HxbQiiC0ewW7vde4S0RVmNT2CWiWY=";
  };

  nativeBuildInputs = [
    cmake
    wrapQtAppsHook
    pkg-config
  ];
  buildInputs = [
    hunspell
    poppler
    qt5compat
    qtbase
    qtsvg
    qttools
    quazip
    zlib
  ];

  meta = with lib; {
    description = "TeX and LaTeX editor";
    longDescription=''
      Fork of TeXMaker, this editor is a full fledged IDE for
      LaTeX editing with completion, structure viewer, preview,
      spell checking and support of any compilation chain.
    '';
    homepage = "https://texstudio.org";
    changelog = "https://github.com/texstudio-org/texstudio/blob/${version}/utilities/manual/CHANGELOG.txt";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ ajs124 cfouche ];
  };
})
