{
  lib,
  stdenv,
  fetchFromGitLab,
  cmake,
  ffmpeg-headless,
  kdePackages,
  pkg-config,
  qt6,
  yt-dlp,
}:

stdenv.mkDerivation rec {
  pname = "haruna";
  version = "1.4.0";

  src = fetchFromGitLab {
    owner = "multimedia";
    repo = "haruna";
    rev = "v${version}";
    hash = "sha256-7983qZ7c3i8Ilyvu36t02zeIcVO96PXGNLH3wq6JsvI=";
    domain = "invent.kde.org";
  };

  postPatch = ''
    substituteInPlace src/application.cpp \
      --replace '"yt-dlp"' '"${lib.getExe yt-dlp}"'
  '';

  buildInputs = [
    kdePackages.breeze-icons
    kdePackages.breeze
    kdePackages.qqc2-desktop-style
    yt-dlp

    ffmpeg-headless
    kdePackages.kconfig
    kdePackages.kcoreaddons
    kdePackages.kdeclarative
    kdePackages.kfilemetadata
    kdePackages.ki18n
    kdePackages.kiconthemes
    kdePackages.kio
    kdePackages.kirigami
    kdePackages.kxmlgui
    kdePackages.kdoctools
    kdePackages.mpvqt
    qt6.qtbase
  ];

  nativeBuildInputs = [
    cmake
    kdePackages.extra-cmake-modules
    pkg-config
    qt6.wrapQtAppsHook
  ];

  meta = {
    homepage = "https://invent.kde.org/multimedia/haruna";
    description = "Open source video player built with Qt/QML and libmpv";
    license = with lib.licenses; [
      bsd3
      cc-by-40
      cc-by-sa-40
      cc0
      gpl2Plus
      gpl3Plus
      wtfpl
    ];
    maintainers = with lib.maintainers; [
      jojosch
      kashw2
    ];
    mainProgram = "haruna";
  };
}
