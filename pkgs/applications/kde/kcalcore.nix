{
  kdeApp, lib, kdeWrapper,
  extra-cmake-modules, kdoctools,
  kdelibs4support, libical
}:
kdeApp {
  name = "kcalcore";
  meta = {
    license = with lib.licenses; [ gpl2 lgpl21 fdl12 ];
    maintainers = [ lib.maintainers.vandenoever ];
  };
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  propagatedBuildInputs = [
    kdelibs4support libical
  ];
}
