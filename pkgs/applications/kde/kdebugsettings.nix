{
  mkDerivation, lib,
  extra-cmake-modules, kdoctools,
  gettext,
  kcoreaddons, kconfig, kdbusaddons, kwidgetsaddons, kitemviews, kcompletion, kxmlgui,
  python3
}:

mkDerivation {
  pname = "kdebugsettings";
  meta = {
    homepage = "https://apps.kde.org/kdebugsettings/";
    description = "KDE debug settings";
    mainProgram = "kdebugsettings";
    license = with lib.licenses; [ gpl2 ];
    maintainers = [ ];
  };
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  buildInputs = [
    gettext kcoreaddons kconfig kdbusaddons kwidgetsaddons kitemviews kcompletion kxmlgui python3
  ];
  propagatedUserEnvPkgs = [ ];
}
