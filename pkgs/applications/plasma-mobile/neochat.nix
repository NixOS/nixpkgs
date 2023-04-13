{ gcc12Stdenv
, lib
, srcs

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
, kquickimageedit
, libpulseaudio
, libquotient
, libsecret
, olm
, qcoro
, qqc2-desktop-style
, qtgraphicaleffects
, qtkeychain
, qtmultimedia
, qtquickcontrols2
, sonnet
}:

# Workaround for AArch64 not using GCC11 yet.
gcc12Stdenv.mkDerivation rec {
  pname = "neochat";
  inherit (srcs.neochat) version src;

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
    kquickimageedit
    libpulseaudio
    libquotient
    libsecret
    olm
    qcoro
    qtgraphicaleffects
    qtkeychain
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
