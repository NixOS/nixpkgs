{
  kdeApp, lib, extra-cmake-modules,
  cups, kconfig, kconfigwidgets, kdbusaddons, kiconthemes, ki18n, kcmutils, kio,
  knotifications, kwidgetsaddons, kwindowsystem, kitemviews, plasma-framework,
  qtdeclarative
}:

kdeApp {
  name = "print-manager";
  meta = {
    license = [ lib.licenses.gpl2 ];
    maintainers = [ lib.maintainers.ttuegel ];
  };
  nativeBuildInputs = [ extra-cmake-modules ];
  propagatedBuildInputs = [
    cups kconfig kconfigwidgets kdbusaddons kiconthemes kcmutils knotifications
    kwidgetsaddons kitemviews ki18n kio kwindowsystem plasma-framework
    qtdeclarative
  ];
}
