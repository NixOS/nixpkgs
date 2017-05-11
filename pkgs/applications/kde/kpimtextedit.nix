{ kdeApp, lib, kdeWrapper
, extra-cmake-modules, kdoctools
, kcodecs, kconfig, kconfigwidgets, kdesignerplugin, kemoticons, kiconthemes, kio
, grantlee, syntax-highlighting
}:

kdeApp {
  name = "kpimtextedit";
  meta.license = with lib.licenses; [ lgpl21 gpl3 ];

  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  propagatedBuildInputs = [
    kcodecs kconfig kconfigwidgets kdesignerplugin kemoticons kiconthemes kio
    grantlee syntax-highlighting
  ];

  enableParallelBuilding = true;
}
