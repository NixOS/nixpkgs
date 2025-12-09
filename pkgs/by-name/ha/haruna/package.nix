{
  lib,
  stdenv,
  fetchFromGitLab,
  cmake,
  ffmpeg-headless,
  kdsingleapplication,
  libass,
  kdePackages,
  pkg-config,
  qt6,
  yt-dlp,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "haruna";
  version = "1.6.0";

  src = fetchFromGitLab {
    owner = "multimedia";
    repo = "haruna";
    rev = "v${finalAttrs.finalPackage.version}";
    hash = "sha256-pAFO6zclJNmHD91ady0vlnBg6ebSWMzJq7TZN/uBGnM=";
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
    kdsingleapplication
    libass
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
    kdePackages.kitemmodels
    qt6.qtbase
  ];

  nativeBuildInputs = [
    cmake
    kdePackages.extra-cmake-modules
    pkg-config
    qt6.wrapQtAppsHook
  ];

  env.LANG = "C.UTF-8";

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
})
