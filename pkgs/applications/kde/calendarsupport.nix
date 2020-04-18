{
  mkDerivation, lib, kdepimTeam,
  extra-cmake-modules, kdoctools,
  akonadi, akonadi-calendar, akonadi-mime, kcalutils, kdepim-apps-libs,
  kholidays, kidentitymanagement, kmime, pimcommon, qttools,
}:

mkDerivation {
  name = "calendarsupport";
  meta = {
    license = with lib.licenses; [ gpl2 lgpl21 fdl12 ];
    maintainers = kdepimTeam;
  };
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  buildInputs = [
    akonadi akonadi-mime kcalutils kdepim-apps-libs kholidays pimcommon qttools
  ];
  propagatedBuildInputs = [ akonadi-calendar kidentitymanagement kmime ];
  outputs = [ "out" "dev" ];
}
