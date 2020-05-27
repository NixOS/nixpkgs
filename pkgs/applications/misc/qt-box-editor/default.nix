{ mkDerivation
, stdenv
, fetchFromGitHub
, qtbase
, qtsvg
, qmake
, leptonica
, tesseract
}:

mkDerivation {
  pname = "qt-box-editor";
  version = "unstable-2019-07-12";

  src = fetchFromGitHub {
    owner = "zdenop";
    repo = "qt-box-editor";
    rev = "75a68b466868ba41ba2886caa796057403fe1901";
    sha256 = "0zwsyy7cnbhy5aazwlkhd9y8bnzlgy1gffqa46abajn4809b95k3";
  };

  buildInputs = [ qtbase qtsvg leptonica tesseract ];

  nativeBuildInputs = [ qmake ];

  # remove with next release
  # https://github.com/zdenop/qt-box-editor/pull/78
  postPatch = ''
    printf "INSTALLS += target\ntarget.path = $out/bin" >>  qt-box-editor.pro
  '';

  meta = with stdenv.lib; {
    description = "Editor of tesseract-ocr box files";
    homepage = "https://github.com/zdenop/qt-box-editor";
    license = licenses.asl20;
    maintainers = [ maintainers.costrouc ];
    platforms = platforms.all;
  };
}
