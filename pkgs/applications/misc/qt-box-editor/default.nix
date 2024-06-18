{ mkDerivation
, lib
, fetchFromGitHub
, qtbase
, qtsvg
, qmake
, leptonica
, tesseract4
}:

mkDerivation {
  pname = "qt-box-editor";
  version = "unstable-2019-07-14";

  src = fetchFromGitHub {
    owner = "zdenop";
    repo = "qt-box-editor";
    rev = "cba2929dabc6c715acd1a282ba161fee914c87f6";
    hash = "sha256-3dWnAu0CLO3atjbC1zJEnL3vzsIEecDDDhW3INMfCv4=";
  };

  buildInputs = [ qtbase qtsvg leptonica tesseract4 ];

  nativeBuildInputs = [ qmake ];

  # https://github.com/zdenop/qt-box-editor/issues/87
  postPatch = ''
    sed -i '/allheaders.h/a#include <leptonica/pix_internal.h>' src/TessTools.h

    substituteInPlace qt-box-editor.pro \
      --replace '-llept' '-lleptonica'
  '';

  meta = with lib; {
    description = "Editor of tesseract-ocr box files";
    mainProgram = "qt-box-editor-1.12rc1";
    homepage = "https://github.com/zdenop/qt-box-editor";
    license = licenses.asl20;
    maintainers = [ maintainers.costrouc ];
    platforms = platforms.all;
  };
}
