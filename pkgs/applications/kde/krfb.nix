{ mkDerivation, lib
, extra-cmake-modules, kdoctools
, kconfig, kcoreaddons, kcrash, kdbusaddons, kdnssd, knotifications, kwallet
, kwidgetsaddons, kwindowsystem, kxmlgui, kwayland
, libvncserver, libXtst, libXdamage
, qtx11extras
}:

mkDerivation {
  pname = "krfb";
  meta = {
    homepage = "https://apps.kde.org/krfb/";
    description = "Desktop sharing (VNC)";
    license = with lib.licenses; [ gpl2 fdl12 ];
    maintainers = with lib.maintainers; [ jerith666 ];
  };
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  buildInputs = [
    libvncserver libXtst libXdamage
    kconfig kcoreaddons kcrash kdbusaddons knotifications kwallet kwidgetsaddons
    kwindowsystem kxmlgui kwayland
    qtx11extras
  ];
  propagatedBuildInputs = [ kdnssd ];
}
