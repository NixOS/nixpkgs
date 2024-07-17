{
  cmake,
  fetchFromGitLab,
  kdePackages,
  lib,
  pkg-config,
  stdenv,
}:

stdenv.mkDerivation rec {
  pname = "francis";
  version = "1.1.0";

  src = fetchFromGitLab {
    domain = "invent.kde.org";
    repo = "francis";
    owner = "utilities";
    rev = "v${version}";
    hash = "sha256-TvLFzGWb3RROGywhNzCvnFG00PpKC2k+/w1bgwTCESg=";
  };

  nativeBuildInputs = [
    cmake
    kdePackages.kirigami
    kdePackages.kirigami-addons
    kdePackages.plasma5support
    kdePackages.qqc2-desktop-style
    kdePackages.qtsvg
    kdePackages.qtwayland
    kdePackages.wrapQtAppsHook
    pkg-config
  ];

  buildInputs = [
    kdePackages.kiconthemes
    # otherwise buttons are blank on non-kde
    kdePackages.breeze-icons
  ];

  cmakeFlags = [
    # fix can't find Qt6QmlCompilerPlusPrivate
    "-DQT_NO_FIND_QMLSC=TRUE"
  ];

  meta = with lib; {
    description = "Using the well-known pomodoro technique to help you get more productive";
    homepage = "https://apps.kde.org/francis/";
    license = with licenses; [
      bsd2
      bsd3
      cc0
      lgpl2Plus
      lgpl21Plus
      gpl3Plus
    ];
    mainProgram = "francis";
    maintainers = with maintainers; [ cimm ];
    platforms = lib.platforms.linux;
  };
}
