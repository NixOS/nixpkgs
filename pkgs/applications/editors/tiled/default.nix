{ lib, mkDerivation, fetchFromGitHub, pkg-config, qmake
, python2, qtbase, qttools }:

mkDerivation rec {
  pname = "tiled";
  version = "1.7.2";

  src = fetchFromGitHub {
    owner = "bjorn";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-yQWe27zLWOnRQk+MEpuWs8CFP/le3PQ+yziB0ikNang=";
  };

  nativeBuildInputs = [ pkg-config qmake ];
  buildInputs = [ python2 qtbase qttools ];

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
