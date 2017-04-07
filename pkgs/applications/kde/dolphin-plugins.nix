{
  kdeApp, lib,
  extra-cmake-modules, kdoctools,
  dolphin, kdelibs4support, ki18n, kio, kxmlgui
}:

kdeApp {
  name = "dolphin-plugins";
  meta = {
    license = [ lib.licenses.gpl2 ];
    maintainers = [ lib.maintainers.ttuegel ];
  };
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  propagatedBuildInputs = [
    dolphin.unwrapped kdelibs4support ki18n kio kxmlgui
  ];
}
