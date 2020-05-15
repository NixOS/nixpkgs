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
  version = "1.8.1";

  src = fetchFromGitHub {
    owner = "gyunaev";
    repo = pname;
    rev = version;
    sha256 = "15l8drdmamq1dpqpj0h9ajj2r5vcs23cx421drvhfgs6bqlzd1hl";
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
