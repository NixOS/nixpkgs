{
  kdeApp, lib,
  extra-cmake-modules, kdoctools,
  grantlee5, kcalcore, kconfig, kontactinterface, kcoreaddons, kdelibs4support,
  kidentitymanagement
}:
kdeApp {
  name = "kcalutils";
  meta = {
    license = with lib.licenses; [ gpl2 lgpl21 fdl12 ];
    maintainers = [ lib.maintainers.vandenoever ];
  };
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  propagatedBuildInputs = [
    grantlee5 kcalcore kconfig kontactinterface kcoreaddons kdelibs4support
    kidentitymanagement
  ];
}
