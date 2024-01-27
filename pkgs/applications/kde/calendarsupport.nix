{
  mkDerivation, lib, kdepimTeam,
  extra-cmake-modules, kdoctools,
  akonadi, akonadi-calendar, akonadi-mime, akonadi-notes, kcalutils,
  kholidays, kidentitymanagement, kmime, pimcommon, qttools,
}:

mkDerivation {
  pname = "calendarsupport";
  meta = {
    license = with lib.licenses; [ gpl2Plus lgpl21Plus fdl12Plus ];
    maintainers = kdepimTeam;
  };
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  buildInputs = [
    akonadi akonadi-mime akonadi-notes kcalutils kholidays pimcommon qttools
  ];
  propagatedBuildInputs = [ akonadi-calendar kidentitymanagement kmime ];
  outputs = [ "out" "dev" ];
  postInstall = ''
    # added as an include directory by cmake files and fails to compile if it's missing
    mkdir -p "$dev/include/KF5"
  '';
}
