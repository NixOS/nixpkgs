{
  kdeApp, lib,
  extra-cmake-modules, kdoctools,
  grantlee5, kiconthemes, knewstuff
}:
kdeApp {
  name = "grantleetheme";
  meta = {
    license = with lib.licenses; [ gpl2 lgpl21 fdl12 ];
    maintainers = [ lib.maintainers.vandenoever ];
  };
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];

  patches = [
    ./grantleetheme_check_null.patch
  ];

  propagatedBuildInputs = [
    grantlee5 kiconthemes knewstuff
  ];
}
