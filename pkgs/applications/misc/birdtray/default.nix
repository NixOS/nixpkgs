{ mkDerivation
  , lib
  , fetchFromGitHub

  , cmake
  , pkgconfig
  , qtbase
  , qttools
  , qtx11extras
  , sqlite
}:

mkDerivation rec {
  pname = "birdtray";
  version = "1.6";

  src = fetchFromGitHub {
    owner = "gyunaev";
    repo = pname;
    rev = "RELEASE_${version}";
    sha256 = "0n6qr224ir59ncid4xbdilk5642z0kcaylzbil1bdcv3h32ysjym";
  };

  nativeBuildInputs = [ cmake pkgconfig ];
  buildInputs = [
    qtbase qtx11extras sqlite
  ];

  installPhase = ''
    install -Dm755 birdtray $out/bin/birdtray
  '';

  meta = with lib; {
    description = "Mail system tray notification icon for Thunderbird";
    homepage = https://github.com/gyunaev/birdtray;
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ Flakebi ];
    platforms = platforms.linux;
  };
}
