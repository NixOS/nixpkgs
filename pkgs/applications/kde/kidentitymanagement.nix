{
  kdeApp, lib, kdeWrapper,
  extra-cmake-modules, kdoctools,
  kcompletion, kcoreaddons, kemoticons, kio, kpimtextedit, ktextwidgets, kxmlgui
}:
kdeApp {
  name = "kidentitymanagement";
  meta = {
    license = with lib.licenses; [ gpl2 lgpl21 fdl12 ];
    maintainers = [ lib.maintainers.vandenoever ];
  };
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  propagatedBuildInputs = [
    kcompletion kcoreaddons kemoticons kio kpimtextedit ktextwidgets kxmlgui
  ];
}
