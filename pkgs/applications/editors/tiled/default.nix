{ stdenv, fetchFromGitHub, pkgconfig, qmake
, python, qtbase, qttools, zlib }:

stdenv.mkDerivation rec {
  name = "tiled-${version}";
  version = "1.1.2";

  src = fetchFromGitHub {
    owner = "bjorn";
    repo = "tiled";
    rev = "v${version}";
    sha256 = "1bzp89914rlrwf2whky3fx10rwxqiwbw9acyqllvam3l4hmv4nlz";
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
    maintainers = with maintainers; [ dywedir ];
    platforms = platforms.linux;
  };
}
