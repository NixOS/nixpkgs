{ stdenv, fetchFromGitHub, pkgconfig, which, qmake, 
  qtbase, qtmultimedia, frei0r, opencolorio, hicolor-icon-theme, ffmpeg-full,
  CoreFoundation  }:

stdenv.mkDerivation rec {
  pname = "olive-editor";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "olive-editor";
    repo = "olive";
    rev = version;
    sha256 = "191nk4c35gys4iypykcidn6h27c3sbjfy117q7h9h1qilz2wm94z";
  };

  nativeBuildInputs = [ 
    pkgconfig 
    which 
    qmake
  ];

  buildInputs = [
    ffmpeg-full
    frei0r
    opencolorio
    qtbase
    qtmultimedia
    qtmultimedia.dev
    hicolor-icon-theme
  ] ++ stdenv.lib.optional stdenv.isDarwin CoreFoundation;

  meta = with stdenv.lib; {
    description = "Professional open-source NLE video editor";
    homepage = "https://www.olivevideoeditor.org/";
    downloadPage = "https://www.olivevideoeditor.org/download.php";
    license = licenses.gpl3;
    maintainers = [ maintainers.balsoft ];
    platforms = platforms.unix;
  };
}
