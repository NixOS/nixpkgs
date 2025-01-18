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
  meta = with lib; {
    homepage = "https://apps.kde.org/kruler/";
    description = "Screen ruler";
    mainProgram = "kruler";
    license = with licenses; [ gpl2 ];
    maintainers = [ maintainers.vandenoever ];
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
