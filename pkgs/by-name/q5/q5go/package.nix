{ stdenv
, lib
, fetchFromGitHub
, pkg-config
, libsForQt5
, autoreconfHook
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "q5go";
  version = "2.1.3";
  src = fetchFromGitHub {
    owner = "bernds";
    repo = "q5Go";
    rev = "q5go-${finalAttrs.version}";
    hash = "sha256-MQ/FqAsBnQVaP9VDbFfEbg5ymteb/NSX4nS8YG49HXU=";
  };

  patches = [
    ./0001-remove-bogus-qtchooser.patch
  ];
  buildInputs = with libsForQt5; [
    qtbase
    qtsvg
    qtmultimedia
  ];
  nativeBuildInputs = [
    libsForQt5.wrapQtAppsHook
    pkg-config
    autoreconfHook
  ];

  meta = with lib; {
    description = "A tool for Go players: SGF editor, analysis tool, game database and pattern search tool, IGS client";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ laalsaas ];
    mainProgram = "q5go";
    platforms = platforms.all;
  };
})
