{
  kdeApp, lib,
  extra-cmake-modules, kdoctools,
  kcalcore, kcalutils, kcontacts, kdelibs4support
}:
kdeApp {
  name = "ktnef";
  meta = {
    license = with lib.licenses; [ gpl2 lgpl21 fdl12 ];
    maintainers = [ lib.maintainers.vandenoever ];
  };
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  propagatedBuildInputs = [
    kcalcore kcalutils kcontacts kdelibs4support
  ];
}
