{ kdeApp, lib, kdeWrapper
, extra-cmake-modules, kdoctools
, kcalcore, kdelibs4support, kidentitymanagement, grantlee
}:

kdeApp {
  name = "kcalutils";
  meta.license = with lib.licenses; [ lgpl21 gpl3 ];

  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  propagatedBuildInputs = [
    kidentitymanagement
    grantlee
    kcalcore kdelibs4support
  ];

  enableParallelBuilding = true;
}
