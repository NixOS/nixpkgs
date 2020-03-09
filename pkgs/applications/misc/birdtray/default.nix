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
  version = "1.7.0";

  src = fetchFromGitHub {
    owner = "gyunaev";
    repo = pname;
    rev = "RELEASE_${version}";
    sha256 = "0wj2lq5bz1p0cf6yj43v3ifxschcrh5amwx30wqw2m4bb8syzjw1";
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
