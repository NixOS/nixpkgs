{ stdenv, fetchFromGitHub, pkgconfig, qmake
, python, qtbase, qttools, zlib }:

let
#  qtEnv = with qt5; env "qt-${qtbase.version}" [ qtbase qttools ];
in stdenv.mkDerivation rec {
  name = "tiled-${version}";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "bjorn";
    repo = "tiled";
    rev = "v${version}";
    sha256 = "062ja3j84v5s4qslp01gqif8c6i1klkkxpxyyrrvjhxmbyn6nmgd";
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
