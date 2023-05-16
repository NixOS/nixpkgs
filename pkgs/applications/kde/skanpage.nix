{ lib
, mkDerivation
<<<<<<< HEAD
=======
, fetchurl
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, extra-cmake-modules
, kirigami2
, ktextwidgets
, libksane
, qtquickcontrols2
, kpurpose
<<<<<<< HEAD
, kquickimageedit
}:

mkDerivation {
=======
}:

mkDerivation rec {
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  pname = "skanpage";

  nativeBuildInputs = [ extra-cmake-modules ];

  buildInputs = [
    kirigami2
    ktextwidgets
    libksane
    qtquickcontrols2
    kpurpose
<<<<<<< HEAD
    kquickimageedit
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  meta = with lib; {
    description = "KDE utility to scan images and multi-page documents";
    homepage = "https://apps.kde.org/skanpage";
    license = licenses.gpl2Plus;
<<<<<<< HEAD
=======
    maintainers = with maintainers; [ ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    platforms = platforms.linux;
  };
}
