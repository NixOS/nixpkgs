{
  mkDerivation, lib,
  extra-cmake-modules, kdoctools,
  gettext,
  kcoreaddons, kconfig, kdbusaddons, kwidgetsaddons, kitemviews, kcompletion,
  python
}:

mkDerivation {
  name = "kdebugsettings";
  meta = {
    license = with lib.licenses; [ gpl2 ];
    maintainers = [ lib.maintainers.rittelle ];
  };
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  buildInputs = [
    gettext kcoreaddons kconfig kdbusaddons kwidgetsaddons kitemviews kcompletion python
  ];
  propagatedUserEnvPkgs = [ ];
}
