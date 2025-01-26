{
  mkDerivation,
  lib,
  extra-cmake-modules,
  kdoctools,
  knotifications,
  kwindowsystem,
  kxmlgui,
  qtx11extras,
}:

mkDerivation {
  pname = "kruler";
  meta = {
    homepage = "https://apps.kde.org/kruler/";
    description = "Screen ruler";
    mainProgram = "kruler";
    license = with lib.licenses; [ gpl2 ];
    maintainers = [ lib.maintainers.vandenoever ];
  };
  nativeBuildInputs = [
    extra-cmake-modules
    kdoctools
  ];
  buildInputs = [
    kwindowsystem
    knotifications
    kxmlgui
    qtx11extras
  ];
}
