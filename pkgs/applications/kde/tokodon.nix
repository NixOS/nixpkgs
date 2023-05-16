{ lib
, mkDerivation

, cmake
, extra-cmake-modules
, pkg-config

, kconfig
, kdbusaddons
, ki18n
, kirigami2
, kirigami-addons
, knotifications
, qqc2-desktop-style
, qtbase
, qtkeychain
, qtmultimedia
, qtquickcontrols2
, qttools
, qtwebsockets
, kitemmodels
, pimcommon
<<<<<<< HEAD
, mpv
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

mkDerivation {
  pname = "tokodon";

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    pkg-config
  ];

  buildInputs = [
    kconfig
    kdbusaddons
    ki18n
    kirigami2
    kirigami-addons
    knotifications
    qqc2-desktop-style
    qtbase
    qtkeychain
    qtmultimedia
    qtquickcontrols2
    qttools
    qtwebsockets
    kitemmodels
    pimcommon
<<<<<<< HEAD
    mpv
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  meta = with lib; {
    description = "A Mastodon client for Plasma and Plasma Mobile";
    homepage = "https://invent.kde.org/network/tokodon";
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ matthiasbeyer ];
  };
}
