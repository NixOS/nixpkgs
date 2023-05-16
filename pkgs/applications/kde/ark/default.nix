{ mkDerivation, lib, extra-cmake-modules, kdoctools
, breeze-icons, karchive, kconfig, kcrash, kdbusaddons, ki18n
, kiconthemes, kitemmodels, khtml, kio, kparts, kpty, kservice, kwidgetsaddons
, libarchive, libzip
# Archive tools
<<<<<<< HEAD
, p7zip, lrzip, unar
=======
, p7zip, lrzip
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
# Unfree tools
, unfreeEnableUnrar ? false, unrar
}:

let
<<<<<<< HEAD
  extraTools = [ p7zip lrzip unar ] ++ lib.optional unfreeEnableUnrar unrar;
=======
  extraTools = [ p7zip lrzip ] ++ lib.optional unfreeEnableUnrar unrar;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
in

mkDerivation {
  pname = "ark";

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [ extra-cmake-modules kdoctools ];

  buildInputs = [ libarchive libzip ] ++ extraTools;

  propagatedBuildInputs = [
    breeze-icons karchive kconfig kcrash kdbusaddons khtml ki18n kiconthemes kio
    kitemmodels kparts kpty kservice kwidgetsaddons
  ];

  qtWrapperArgs = [ "--prefix" "PATH" ":" (lib.makeBinPath extraTools) ];

  meta = with lib; {
    homepage = "https://apps.kde.org/ark/";
    description = "Graphical file compression/decompression utility";
    license = with licenses; [ gpl2 lgpl3 ] ++ optional unfreeEnableUnrar unfree;
    maintainers = [ maintainers.ttuegel ];
  };
}
