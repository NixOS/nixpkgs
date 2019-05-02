{ stdenv, fetchFromGitHub, pkgconfig, qmake
, python, qtbase, qttools }:

stdenv.mkDerivation rec {
  pname = "tiled";
  version = "1.2.3";

  src = fetchFromGitHub {
    owner = "bjorn";
    repo = pname;
    rev = "v${version}";
    sha256 = "1zsfhw539zwyf5qfnirzkkgy5bmrrs2cry4gimrhpky9fjlaa9h8";
  };

  nativeBuildInputs = [ pkgconfig qmake ];
  buildInputs = [ python qtbase qttools ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Free, easy to use and flexible tile map editor";
    homepage = https://www.mapeditor.org/;
    license = with licenses; [
      bsd2	# libtiled and tmxviewer
      gpl2Plus	# all the rest
    ];
    maintainers = with maintainers; [ dywedir ];
    platforms = platforms.linux;
  };
}
