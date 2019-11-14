{
  mkDerivation, lib,
  extra-cmake-modules,
  cups, ki18n,
  kconfig, kconfigwidgets, kdbusaddons, kiconthemes, kcmutils, kio,
  knotifications, kwidgetsaddons, kwindowsystem, kitemviews, plasma-framework,
  qtdeclarative
}:

mkDerivation {
  name = "print-manager";
  meta = {
    license = [ lib.licenses.gpl2 ];
    maintainers = [ lib.maintainers.ttuegel ];
  };
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [ cups ki18n ];
  propagatedBuildInputs = [
    kconfig kconfigwidgets kdbusaddons kiconthemes kcmutils knotifications
    kwidgetsaddons kitemviews kio kwindowsystem plasma-framework qtdeclarative
  ];

  # /build/print-manager-19.08.2/libkcups/KIppRequest.cpp:192:65: error: format not a string literal and no format arguments [-Werror=format-security]
  hardeningDisable = [ "format" ];

  outputs = [ "out" "dev" ];
}
