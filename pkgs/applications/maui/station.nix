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
<<<<<<< HEAD
, mauikit-terminal
, qmltermwidget
, qtmultimedia
=======
, qmltermwidget
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
    mauikit-terminal
    qmltermwidget
    qtmultimedia
=======
    qmltermwidget
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  meta = with lib; {
    description = "Convergent terminal emulator";
    homepage = "https://invent.kde.org/maui/station";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ onny ];
  };
}
