{ mkDerivation
, lib
, fetchpatch

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

mkDerivation {
  pname = "neochat";

  patches = [
    (fetchpatch {
      name = "libquotient-0.8.patch";
      url = "https://invent.kde.org/network/neochat/-/commit/d9d5e17be2a2057ab2ee545561fab721cb211f7f.patch";
      hash = "sha256-y1PEehFCW+69OH8YvL3SUGOb8Hhyf8xwRvSZzJ5J5Wc=";
    })
  ];

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
