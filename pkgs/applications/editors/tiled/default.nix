{ lib, mkDerivation, fetchFromGitHub, pkg-config, qmake
, python, qtbase, qttools }:

mkDerivation rec {
  pname = "tiled";
  version = "1.4.3";

  src = fetchFromGitHub {
    owner = "bjorn";
    repo = pname;
    rev = "v${version}";
    sha256 = "0n8p7bp5pqq72c65av3v7wbazwphh78pw27nqvpiyp9y8k5w4pg0";
  };

  nativeBuildInputs = [ pkg-config qmake ];
  buildInputs = [ python qtbase qttools ];

  enableParallelBuilding = true;

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
