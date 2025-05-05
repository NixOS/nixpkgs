{
  lib,
  mkDerivation,

  cmake,
  extra-cmake-modules,
  pkg-config,

  kconfig,
  kdbusaddons,
  ki18n,
  kirigami2,
  kirigami-addons,
  knotifications,
  qqc2-desktop-style,
  qtbase,
  qtkeychain,
  qtmultimedia,
  qtquickcontrols2,
  qttools,
  qtwebsockets,
  kitemmodels,
  pimcommon,
  mpv,
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
    mpv
  ];

  meta = with lib; {
    description = "Mastodon client for Plasma and Plasma Mobile";
    mainProgram = "tokodon";
    homepage = "https://invent.kde.org/network/tokodon";
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ matthiasbeyer ];
  };
}
