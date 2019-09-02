{ stdenv, fetchFromGitHub, pkgconfig, which, qmake, mkDerivation,
  qtbase, qtmultimedia, frei0r, opencolorio, hicolor-icon-theme, ffmpeg-full,
  CoreFoundation  }:

mkDerivation rec {
  pname = "olive-editor";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "olive-editor";
    repo = "olive";
    rev = version;
    sha256 = "15q4qwf5rc3adssywl72jrhkpqk55ihpd5h5wf07baw0s47vv5kq";
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
