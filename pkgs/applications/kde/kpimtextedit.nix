{
  kdeApp, lib, kdeWrapper,
  extra-cmake-modules, kdoctools,
  grantlee5, kcodecs, kconfigwidgets, kemoticons, kiconthemes, kio,
  kdesignerplugin, syntax-highlighting
}:
kdeApp {
  name = "kpimtextedit";
  meta = {
    license = with lib.licenses; [ gpl2 lgpl21 fdl12 ];
    maintainers = [ lib.maintainers.vandenoever ];
  };
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  propagatedBuildInputs = [
    grantlee5 kcodecs kconfigwidgets kemoticons kiconthemes kio kdesignerplugin
    syntax-highlighting
  ];
}
