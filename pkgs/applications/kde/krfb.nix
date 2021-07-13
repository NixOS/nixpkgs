{
  mkDerivation, lib,
  extra-cmake-modules, kdoctools,
  kconfig, kcoreaddons, kcrash, kdbusaddons, kdnssd, knotifications, kwallet,
  kwidgetsaddons, kwindowsystem, kxmlgui,
  libvncserver, libXtst, libXdamage,
  qtx11extras
}:

mkDerivation {
  pname = "krfb";
  meta = {
    license = with lib.licenses; [ gpl2 fdl12 ];
    maintainers = with lib.maintainers; [ jerith666 ];
  };
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  buildInputs = [
    libvncserver libXtst libXdamage
    kconfig kcoreaddons kcrash kdbusaddons knotifications kwallet kwidgetsaddons
    kwindowsystem kxmlgui
    qtx11extras
  ];
  propagatedBuildInputs = [ kdnssd ];
}
