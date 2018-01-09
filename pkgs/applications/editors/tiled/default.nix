{ stdenv, fetchFromGitHub, pkgconfig, qmake
, python, qtbase, qttools, zlib }:

stdenv.mkDerivation rec {
  name = "tiled-${version}";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "bjorn";
    repo = "tiled";
    rev = "v${version}";
    sha256 = "1c6n5xshadxv5qwv8kfrj1kbfnkvx6nyxc9p4mpzkjrkxw1b1qf1";
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
