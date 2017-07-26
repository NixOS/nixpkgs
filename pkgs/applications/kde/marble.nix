{ mkDerivation, lib
, extra-cmake-modules, kdoctools
, qtscript, qtsvg, qtquickcontrols, qtwebkit
, krunner, shared_mime_info, kparts, knewstuff
, gpsd, perl
}:

mkDerivation {
  name = "marble";
  meta.license = with lib.licenses; [ lgpl21 gpl3 ];
  nativeBuildInputs = [ extra-cmake-modules kdoctools perl ];
  propagatedBuildInputs = [
    qtscript qtsvg qtquickcontrols qtwebkit shared_mime_info krunner kparts
    knewstuff gpsd
  ];
}
