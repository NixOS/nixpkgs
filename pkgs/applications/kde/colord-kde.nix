{ mkDerivation, lib
, extra-cmake-modules, ki18n
<<<<<<< HEAD
, kconfig, kconfigwidgets, kcoreaddons, kdbusaddons, kiconthemes, kirigami-addons
, kcmutils, kio, knotifications, plasma-framework, kwidgetsaddons
, kwindowsystem, kitemmodels, kitemviews, lcms2, libXrandr, qtx11extras
=======
, kconfig, kconfigwidgets, kcoreaddons, kdbusaddons, kiconthemes, kcmutils
, kio, knotifications, plasma-framework, kwidgetsaddons, kwindowsystem
, kitemmodels, kitemviews, lcms2, libXrandr, qtx11extras
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

mkDerivation {
  pname = "colord-kde";

  nativeBuildInputs = [ extra-cmake-modules ];

  buildInputs = [
<<<<<<< HEAD
    kconfig kconfigwidgets kcoreaddons kdbusaddons kiconthemes kirigami-addons
=======
    kconfig kconfigwidgets kcoreaddons kdbusaddons kiconthemes
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    kcmutils ki18n kio knotifications plasma-framework kwidgetsaddons
    kwindowsystem kitemmodels kitemviews lcms2 libXrandr qtx11extras
  ];

  meta = with lib; {
    homepage = "https://projects.kde.org/projects/playground/graphics/colord-kde";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ ttuegel ];
  };
}
