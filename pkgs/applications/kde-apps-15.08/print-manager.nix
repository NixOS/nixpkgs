{ kdeApp
, lib
, extra-cmake-modules
, qtdeclarative
, cups
, kconfig
, kconfigwidgets
, kdbusaddons
, kiconthemes
, ki18n
, kcmutils
, kio
, knotifications
, plasma-framework
, kwidgetsaddons
, kwindowsystem
, kitemviews
}:

kdeApp {
  name = "print-manager";
  nativeBuildInputs = [
    extra-cmake-modules
  ];
  buildInputs = [
    cups
    kconfig
    kconfigwidgets
    kdbusaddons
    kiconthemes
    kcmutils
    knotifications
    plasma-framework
    kwidgetsaddons
    kitemviews
  ];
  propagatedBuildInputs = [
    ki18n
    kio
    kwindowsystem
    qtdeclarative
  ];
  meta = {
    license = [ lib.licenses.gpl2 ];
    maintainers = [ lib.maintainers.ttuegel ];
  };
}
