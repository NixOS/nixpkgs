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
  version = "1.11.4";

  src = fetchFromGitHub {
    owner = "gyunaev";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-rj8tPzZzgW0hXmq8c1LiunIX1tO/tGAaqDGJgCQda5M=";
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
    mainProgram = "birdtray";
    homepage = "https://github.com/gyunaev/birdtray";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ Flakebi ];
    platforms = platforms.linux;
  };
}
