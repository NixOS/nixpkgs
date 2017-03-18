{ kdeApp, lib, kdeWrapper
, extra-cmake-modules, qtscript, qtsvg, qtquickcontrols
, gpsd
}:

let
  unwrapped =
    kdeApp {
      name = "marble";
      meta.license = with lib.licenses; [ lgpl21 gpl3 ];

      nativeBuildInputs = [ extra-cmake-modules ];
      propagatedBuildInputs = [
        qtscript qtsvg qtquickcontrols
        gpsd
      ];

      enableParallelBuilding = true;
    };
in
kdeWrapper {
  inherit unwrapped;
  targets = [ "bin/marble-qt" ];
  paths = [ unwrapped ];
}
