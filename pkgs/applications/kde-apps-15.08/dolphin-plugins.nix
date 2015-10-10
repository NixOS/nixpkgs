{ kdeApp
, lib
, extra-cmake-modules
, kdoctools
, kxmlgui
, ki18n
, kio
, kdelibs4support
, dolphin
}:

kdeApp {
  name = "dolphin-plugins";
  nativeBuildInputs = [
    extra-cmake-modules
    kdoctools
  ];
  buildInputs = [
    kxmlgui
    ki18n
    kio
    dolphin
  ];
  propagatedBuildInputs = [
    kdelibs4support
  ];
  meta = {
    license = [ lib.licenses.gpl2 ];
    maintainers = [ lib.maintainers.ttuegel ];
  };
}
