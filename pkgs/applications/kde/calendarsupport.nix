{
  mkDerivation, lib, kdepimTeam,
  extra-cmake-modules, kdoctools,
  akonadi, akonadi-calendar, akonadi-mime, akonadi-notes, kcalutils,
  kholidays, kidentitymanagement, kmime, pimcommon, qttools,
}:

mkDerivation {
  pname = "calendarsupport";
  meta = {
    license = with lib.licenses; [ gpl2 lgpl21 fdl12 ];
    maintainers = kdepimTeam;
  };
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  buildInputs = [
    akonadi akonadi-mime akonadi-notes kcalutils kholidays pimcommon qttools
  ];
  propagatedBuildInputs = [ akonadi-calendar kidentitymanagement kmime ];
  outputs = [ "out" "dev" ];
}
