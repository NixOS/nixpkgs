{ stdenv, fetchFromGitHub, pkgconfig, qmakeHook
, python, qtbase, qttools, zlib }:

let
#  qtEnv = with qt5; env "qt-${qtbase.version}" [ qtbase qttools ];
in stdenv.mkDerivation rec {
  name = "tiled-${version}";
  version = "0.18.2";

  src = fetchFromGitHub {
    owner = "bjorn";
    repo = "tiled";
    rev = "v${version}";
    sha256 = "087jl36g6w2g5l70gz573iwyvx3r7i8fijl3y4mmmf8pyqdyq1n2";
  };

  nativeBuildInputs = [ pkgconfig qmakeHook ];
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
