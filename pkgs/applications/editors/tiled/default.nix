{ stdenv, fetchFromGitHub, pkgconfig, qmake
, python, qtbase, qttools }:

stdenv.mkDerivation rec {
  name = "tiled-${version}";
  version = "1.2.1";

  src = fetchFromGitHub {
    owner = "bjorn";
    repo = "tiled";
    rev = "v${version}";
    sha256 = "077fv3kn3fy06z8f414r3ny4a04l05prppmkyvjqhnwf1i1jck1w";
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
