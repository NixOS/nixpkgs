{ mkDerivation
  , lib
  , fetchFromGitHub

  , cmake
  , pkg-config
  , qtbase
  , qttools
  , qtx11extras
}:

mkDerivation rec {
  pname = "birdtray";
  version = "1.9.0";

  src = fetchFromGitHub {
    owner = "gyunaev";
    repo = pname;
    rev = "v${version}";
    sha256 = "1469ng6zk0qx0qfsihrnlz1j9i1wk0hx4vqdaplz9mdpyxvmlryk";
  };

  nativeBuildInputs = [ cmake pkg-config ];
  buildInputs = [
    qtbase qttools qtx11extras
  ];

  # Wayland support is broken.
  # https://github.com/gyunaev/birdtray/issues/113#issuecomment-621742315
  qtWrapperArgs = [ "--set QT_QPA_PLATFORM xcb" ];

  meta = with lib; {
    description = "Mail system tray notification icon for Thunderbird";
    homepage = "https://github.com/gyunaev/birdtray";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ Flakebi oxalica ];
    platforms = platforms.linux;
  };
}
