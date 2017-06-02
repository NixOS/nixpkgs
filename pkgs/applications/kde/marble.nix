{ mkDerivation, lib, kdeWrapper
, extra-cmake-modules, kdoctools
, qtscript, qtsvg, qtquickcontrols, qtwebkit
, krunner, shared_mime_info, kparts, knewstuff
, gpsd, perl
}:

let
  unwrapped =
    mkDerivation {
      name = "marble";
      meta.license = with lib.licenses; [ lgpl21 gpl3 ];

      nativeBuildInputs = [ extra-cmake-modules kdoctools perl ];
      propagatedBuildInputs = [
        qtscript qtsvg qtquickcontrols qtwebkit shared_mime_info
        krunner kparts knewstuff
        gpsd
      ];

      enableParallelBuilding = true;
    };
in
kdeWrapper {
  inherit unwrapped;
  targets = [ "bin/marble-qt" "bin/marble" ];
  paths = [ unwrapped ];
}
