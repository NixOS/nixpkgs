{ stdenv, fetchFromGitHub, pkgconfig, qmake
, python, qtbase, qttools, zlib }:

let
#  qtEnv = with qt5; env "qt-${qtbase.version}" [ qtbase qttools ];
in stdenv.mkDerivation rec {
  name = "tiled-${version}";
  version = "1.0.3";

  src = fetchFromGitHub {
    owner = "bjorn";
    repo = "tiled";
    rev = "v${version}";
    sha256 = "1j8307h7xkxqwr8rpr9fn1svm5h10k61w6zxr4sgph1hiv8x33aa";
  };

  nativeBuildInputs = [ pkgconfig qmake ];
  buildInputs = [ python qtbase qttools ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Free, easy to use and flexible tile map editor";
    homepage = http://www.mapeditor.org/;
    license = with licenses; [
      bsd2	# libtiled and tmxviewer
      gpl2Plus	# all the rest
    ];
    platforms = platforms.linux;
    maintainers = [ maintainers.nckx ];
  };
}
