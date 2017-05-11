{ kdeApp, lib, kdeWrapper
, extra-cmake-modules, kdoctools
, kcalcore, kcalutils, kcontacts, kdelibs4support
}:

kdeApp {
  name = "ktnef";
  meta.license = with lib.licenses; [ lgpl21 gpl3 ];

  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  propagatedBuildInputs = [
    kcalcore kcalutils kcontacts
    kdelibs4support
  ];

  enableParallelBuilding = true;
}
