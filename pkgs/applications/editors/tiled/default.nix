{ lib, mkDerivation, fetchFromGitHub, pkg-config, qmake
, python3, qtbase, qttools }:

mkDerivation rec {
  pname = "tiled";
  version = "1.8.2";

  src = fetchFromGitHub {
    owner = "bjorn";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-5yh0+Z6SbHEFKvCJjQY9BS8vUihBspGhFjfhrUOfiIo=";
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
