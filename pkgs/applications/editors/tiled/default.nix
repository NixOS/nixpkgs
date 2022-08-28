{ lib, mkDerivation, fetchFromGitHub, pkg-config, qmake
, python3, qtbase, qttools }:

mkDerivation rec {
  pname = "tiled";
  version = "1.9.1";

  src = fetchFromGitHub {
    owner = "bjorn";
    repo = pname;
    rev = "v${version}";
    sha256 = "13qk64v159w7znca3zd8li3x5j7spwzlkmac0qxws7zhns93d021";
  };

  nativeBuildInputs = [ pkg-config qmake ];
  buildInputs = [ python3 qtbase qttools ];

  meta = with lib; {
    description = "Free, easy to use and flexible tile map editor";
    homepage = "https://www.mapeditor.org/";
    license = with licenses; [
      bsd2	# libtiled and tmxviewer
      gpl2Plus	# all the rest
    ];
    maintainers = with maintainers; [ dywedir ];
    platforms = platforms.linux;
  };
}
