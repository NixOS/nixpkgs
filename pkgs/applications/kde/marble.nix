{ mkDerivation, lib
, extra-cmake-modules, kdoctools
, qtscript, qtsvg, qtquickcontrols, qtwebengine
, krunner, shared-mime-info, kparts, knewstuff
<<<<<<< HEAD
, gpsd, perl, protobuf3_21
=======
, gpsd, perl
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

mkDerivation {
  pname = "marble";
  meta = {
    homepage = "https://apps.kde.org/marble/";
    description = "Virtual globe";
    license = with lib.licenses; [ lgpl21 gpl3 ];
  };
  outputs = [ "out" "dev" ];
  nativeBuildInputs = [ extra-cmake-modules kdoctools perl ];
  propagatedBuildInputs = [
<<<<<<< HEAD
    protobuf3_21 qtscript qtsvg qtquickcontrols qtwebengine shared-mime-info krunner kparts
=======
    qtscript qtsvg qtquickcontrols qtwebengine shared-mime-info krunner kparts
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    knewstuff gpsd
  ];
  preConfigure = ''
    cmakeFlags+=" -DINCLUDE_INSTALL_DIR=''${!outputDev}/include"
  '';
}
