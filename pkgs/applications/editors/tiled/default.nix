{ lib, mkDerivation, fetchFromGitHub, pkg-config, qmake
, python3, qtbase, qttools }:

mkDerivation rec {
  pname = "tiled";
  version = "1.9.1";

  src = fetchFromGitHub {
    owner = "bjorn";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-QYA2krbwH807BkzVST+/+sjSR6So/aGY/YenEjYxE48=";
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
