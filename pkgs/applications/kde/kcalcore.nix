{ kdeApp, lib, kdeWrapper
, extra-cmake-modules, kdoctools
, kdelibs4support, libical
}:

kdeApp {
  name = "kcalcore";
  meta.license = with lib.licenses; [ lgpl21 gpl3 ];

  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  propagatedBuildInputs = [
    kdelibs4support libical
  ];

  enableParallelBuilding = true;
}
