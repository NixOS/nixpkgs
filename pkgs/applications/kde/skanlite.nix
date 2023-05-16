{
  mkDerivation, lib,
<<<<<<< HEAD
  wrapGAppsHook,
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  extra-cmake-modules, kdoctools,
  kio, libksane
}:

mkDerivation {
  pname = "skanlite";
  meta = with lib; {
    description = "KDE simple image scanning application";
    homepage    = "https://apps.kde.org/skanlite";
    license     = licenses.gpl2Plus;
    maintainers = with maintainers; [ polendri ];
  };

<<<<<<< HEAD
  nativeBuildInputs = [ wrapGAppsHook extra-cmake-modules kdoctools ];
=======
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  buildInputs = [ kio libksane ];
}
