{ lib
, mkDerivation
, cmake
, extra-cmake-modules
, applet-window-buttons
, karchive
, kcoreaddons
, ki18n
, kio
, kirigami2
, mauikit
, mauikit-accounts
, mauikit-filebrowsing
, qtmultimedia
, qtquickcontrols2
, taglib
}:

mkDerivation {
  pname = "vvave";

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
  ];

  buildInputs = [
    applet-window-buttons
    karchive
    kcoreaddons
    ki18n
    kio
    kirigami2
    mauikit
    mauikit-accounts
    mauikit-filebrowsing
    qtmultimedia
    qtquickcontrols2
    taglib
  ];

  meta = with lib; {
    description = "Multi-platform media player";
    homepage = "https://invent.kde.org/maui/vvave";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ onny ];
  };
}

