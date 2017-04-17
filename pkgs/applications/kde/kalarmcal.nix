{
  kdeApp, lib,
  extra-cmake-modules, kdoctools,
  akonadi, kcalcore, kdelibs4support, kholidays, kidentitymanagement
}:
kdeApp {
  name = "kalarmcal";
  meta = {
    license = with lib.licenses; [ gpl2 lgpl21 fdl12 ];
    maintainers = [ lib.maintainers.vandenoever ];
  };
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  propagatedBuildInputs = [
    akonadi kcalcore kdelibs4support kholidays kidentitymanagement
  ];
}
