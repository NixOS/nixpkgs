{
  mkDerivation, lib,
  extra-cmake-modules, kdoctools,
  gettext,
  kcoreaddons, kconfig, kdbusaddons, kwidgetsaddons, kitemviews, kcompletion,
  python3
}:

mkDerivation {
  pname = "kdebugsettings";
  meta = {
    homepage = "https://apps.kde.org/kdebugsettings/";
    description = "KDE debug settings";
    license = with lib.licenses; [ gpl2 ];
    maintainers = [ ];
  };
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  buildInputs = [
    gettext kcoreaddons kconfig kdbusaddons kwidgetsaddons kitemviews kcompletion python3
  ];
  propagatedUserEnvPkgs = [ ];
}
