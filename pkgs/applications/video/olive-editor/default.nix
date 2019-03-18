{ stdenv, fetchFromGitHub, pkgconfig, which, qmake, 
  qtbase, qtmultimedia, frei0r, opencolorio, hicolor-icon-theme, ffmpeg-full,
  CoreFoundation  }:

stdenv.mkDerivation {
  pname = "olive-editor";

  version = "unstable-2019-03-18";

  src = fetchFromGitHub {
    owner = "olive-editor";
    repo = "olive";
    rev = "d153e4d7471122987098087a203323003ae8a128";
    sha256 = "1gxpz6jg6dqjmvqkk0m9g4pz30lklwx51d73gka404a3w1j5wna6";
  };

  nativeBuildInputs = [ 
    pkgconfig 
    which 
    qmake
  ];

  buildInputs = [
    ffmpeg-full
    opencolorio
    qtbase
    qtmultimedia
    qtmultimedia.dev
    hicolor-icon-theme
  ] ++ stdenv.lib.optional stdenv.isDarwin CoreFoundation
    ++ stdenv.lib.optional stdenv.isLinux frei0r;

  meta = with stdenv.lib; {
    description = "Professional open-source NLE video editor";
    homepage = "https://www.olivevideoeditor.org/";
    downloadPage = "https://www.olivevideoeditor.org/download.php";
    license = licenses.gpl3;
    maintainers = [ maintainers.balsoft ];
    platforms = platforms.unix;
  };
}
