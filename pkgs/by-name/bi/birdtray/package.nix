{ stdenv
, lib
, fetchFromGitHub
, cmake
, pkg-config
, libsForQt5
, fetchpatch
, thunderbird
}:

stdenv.mkDerivation rec {
  pname = "birdtray";
  version = "1.11.4";

  src = fetchFromGitHub {
    owner = "gyunaev";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-rj8tPzZzgW0hXmq8c1LiunIX1tO/tGAaqDGJgCQda5M=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    libsForQt5.wrapQtAppsHook
  ];

  buildInputs = [
    libsForQt5.qtbase
    libsForQt5.qttools
    libsForQt5.qtx11extras
  ];

  cmakeFlags = [
    (lib.cmakeFeature "OPT_THUNDERBIRD_CMDLINE" "thunderbird") # get thunderbird from PATH
  ];

  patches = [
    (fetchpatch {
      name = "fix-path-handling.patch";
      url = "https://github.com/gyunaev/birdtray/commit/54b304d92188429792c264b07ff45897699f2d3e.patch";
      hash = "sha256-ME635Kt1b9RJKCqtAZBFa93OIA0u2Z4tWIlGcI374j0=";
    })
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
