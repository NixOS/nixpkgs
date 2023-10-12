{ mkDerivation
, lib

, cmake
, extra-cmake-modules
, pkg-config
, wrapQtAppsHook

, cmark
, kconfig
, kdbusaddons
, ki18n
, kio
, kirigami-addons
, kirigami2
, kitemmodels
, knotifications
, kquickcharts
, kquickimageedit
, libpulseaudio
, libquotient
, libsecret
, olm
, qcoro
, qqc2-desktop-style
, qtgraphicaleffects
, qtkeychain
, qtlocation
, qtmultimedia
, qtquickcontrols2
, sonnet
}:

mkDerivation {
  pname = "neochat";

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    pkg-config
    wrapQtAppsHook
  ];

  buildInputs = [
    cmark
    kconfig
    kdbusaddons
    kio
    ki18n
    kirigami-addons
    kirigami2
    kitemmodels
    knotifications
    kquickcharts
    kquickimageedit
    libpulseaudio
    libquotient
    libsecret
    olm
    qcoro
    qtgraphicaleffects
    qtkeychain
    qtlocation
    qtmultimedia
    qtquickcontrols2
    qqc2-desktop-style
    sonnet
  ];

  meta = with lib; {
    description = "A client for matrix, the decentralized communication protocol";
    homepage = "https://apps.kde.org/en/neochat";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ peterhoeg ];
    platforms = with platforms; linux;
  };
}
