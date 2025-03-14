{
  stdenv,
  lib,
  fetchFromGitLab,
  cmake,
  qt5,
  apr,
  aprutil,
  subversion,
  subversionClient,
  libsForQt5,
  extra-cmake-modules,
}:

stdenv.mkDerivation {
  pname = "kdesvn";
  version = "2.1";

  src = fetchFromGitLab {
    domain = "invent.kde.org";
    owner = "sdk";
    repo = "kdesvn";
    rev = "2028bc2f3621510db05e437e33f5cc225a7cd16b";
    hash = "sha256-IaERXT648v2nTW89V6gpf7Dt95GJd92QmC50de+Knq8=";
  };

  cmakeFlags = [
    "-DSUBVERSION_INSTALL_PATH=${lib.getDev subversion}"
  ];

  nativeBuildInputs = [
    cmake
    qt5.wrapQtAppsHook
    apr.dev
    aprutil.dev
    extra-cmake-modules
  ];

  buildInputs = [
    qt5.qtbase
    subversion
    subversionClient
    libsForQt5.kbookmarks
    libsForQt5.kcodecs
    libsForQt5.kcompletion
    libsForQt5.kconfig
    libsForQt5.kconfigwidgets
    libsForQt5.kcoreaddons
    libsForQt5.kdbusaddons
    libsForQt5.kdoctools
    libsForQt5.ki18n
    libsForQt5.kiconthemes
    libsForQt5.kitemviews
    libsForQt5.kjobwidgets
    libsForQt5.kio
    libsForQt5.knotifications
    libsForQt5.kparts
    libsForQt5.kservice
    libsForQt5.ktextwidgets
    libsForQt5.kwallet
    libsForQt5.kwidgetsaddons
    libsForQt5.kxmlgui
  ];

  meta = {
    homepage = "https://invent.kde.org/sdk/kdesvn";
    platforms = lib.platforms.unix;
    badPlatforms = lib.platforms.darwin;
    maintainers = with lib.maintainers; [ bot-wxt1221 ];
    mainProgram = "kdesvn";
    description = "Subversion client by KDE";
    license = lib.licenses.agpl3Plus;
  };
}
