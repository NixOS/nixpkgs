{ lib
, mkDerivation
, cmake
, extra-cmake-modules
, kconfig
, kcoreaddons
, ki18n
, kirigami2
, mauikit
, mauikit-filebrowsing
, mauikit-terminal
, qmltermwidget
, qtmultimedia
}:

mkDerivation {
  pname = "station";

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
  ];

  buildInputs = [
    kconfig
    kcoreaddons
    ki18n
    kirigami2
    mauikit
    mauikit-filebrowsing
    mauikit-terminal
    qmltermwidget
    qtmultimedia
  ];

  meta = with lib; {
    description = "Convergent terminal emulator";
    homepage = "https://invent.kde.org/maui/station";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ onny ];
  };
}
