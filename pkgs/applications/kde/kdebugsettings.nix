{
  mkDerivation, lib,
  extra-cmake-modules, kdoctools,
  gettext,
  kcoreaddons, kconfig, kdbusaddons, kwidgetsaddons, kitemviews, kcompletion,
  qtbase, python
}:

mkDerivation {
  pname = "kdebugsettings";
  meta = {
    license = with lib.licenses; [ gpl2 ];
    maintainers = [ lib.maintainers.rittelle ];
    broken = lib.versionOlder qtbase.version "5.13";
  };
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  buildInputs = [
    gettext kcoreaddons kconfig kdbusaddons kwidgetsaddons kitemviews kcompletion python
  ];
  propagatedUserEnvPkgs = [ ];
}
