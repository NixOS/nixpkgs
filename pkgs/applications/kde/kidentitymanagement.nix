{ kdeApp, lib, kdeWrapper
, extra-cmake-modules, kdoctools
, kcoreaddons, kcompletion, kemoticons, kio, kpimtextedit, ktextwidgets, kxmlgui
}:

kdeApp {
  name = "kidentitymanagement";
  meta.license = with lib.licenses; [ lgpl21 gpl3 ];

  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  propagatedBuildInputs = [
    kcoreaddons kcompletion kemoticons kio kpimtextedit ktextwidgets kxmlgui
  ];

  enableParallelBuilding = true;
}
