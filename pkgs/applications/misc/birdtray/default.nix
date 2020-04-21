{ mkDerivation
  , lib
  , fetchFromGitHub

  , cmake
  , pkgconfig
  , qtbase
  , qttools
  , qtx11extras
}:

mkDerivation rec {
  pname = "birdtray";
  version = "1.8.0";

  src = fetchFromGitHub {
    owner = "gyunaev";
    repo = pname;
    rev = version;
    sha256 = "15d0gz889vf9b2a046m93s5kdi6lw2sqjd5gaxgjkjrs20x5vr18";
  };

  nativeBuildInputs = [ cmake pkgconfig ];
  buildInputs = [
    qtbase qttools qtx11extras
  ];

  meta = with lib; {
    description = "Mail system tray notification icon for Thunderbird";
    homepage = "https://github.com/gyunaev/birdtray";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ Flakebi ];
    platforms = platforms.linux;
  };
}
