{
  kdeApp, lib,
  extra-cmake-modules, kdoctools,
  kconfig, kio, ktextwidgets, kwidgetsaddons, pimcommon
}:
kdeApp {
  name = "libgravatar";
  meta = {
    license = with lib.licenses; [ gpl2 lgpl21 fdl12 ];
    maintainers = [ lib.maintainers.vandenoever ];
  };
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  propagatedBuildInputs = [
    kconfig kio ktextwidgets kwidgetsaddons pimcommon
  ];
}
