{ stdenv, fetchFromGitHub, pkgconfig, which, cmake, mkDerivation,
  qtbase, qtmultimedia, qt5,
  frei0r, opencolorio, openimageio, openexr, ffmpeg-full, CoreFoundation  }:

mkDerivation rec {
  pname = "olive-editor";
  version = "snapshot-2020-04-08";

  src = /home/aengelen/dev/olive;
  /*fetchFromGitHub {
    owner = "olive-editor";
    repo = "olive";
    rev = version;
    sha256 = "151g6jwhipgbq4llwib92sq23p1s9hm6avr7j4qq3bvykzrm8z1a";
  };*/

  nativeBuildInputs = [
    pkgconfig
    which
    cmake
  ];

  buildInputs = [
    ffmpeg-full
    frei0r
    opencolorio
    openimageio
    openexr
    qtbase
    qt5.qttools.dev
    qtmultimedia
    qtmultimedia.dev
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
