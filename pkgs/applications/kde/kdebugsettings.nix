{
  mkDerivation, lib,
  extra-cmake-modules, kdoctools,
  gettext,
  kcoreaddons, kconfig, kdbusaddons, kwidgetsaddons, kitemviews, kcompletion,
  qtbase, python3
}:

mkDerivation {
  pname = "kdebugsettings";
  meta = {
    homepage = "https://apps.kde.org/kdebugsettings/";
    description = "KDE debug settings";
    license = with lib.licenses; [ gpl2 ];
    maintainers = [ lib.maintainers.rittelle ];
    broken = lib.versionOlder qtbase.version "5.13";
  };
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  buildInputs = [
    gettext kcoreaddons kconfig kdbusaddons kwidgetsaddons kitemviews kcompletion python3
  ];
  propagatedUserEnvPkgs = [ ];
}
