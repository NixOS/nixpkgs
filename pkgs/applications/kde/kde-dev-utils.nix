{ mkDerivation, lib, extra-cmake-modules, kdoctools, kparts }:

mkDerivation {
  name = "kde-dev-utils";
  meta = with lib; {
    homepage = "https://invent.kde.org/sdk/kde-dev-utils";
    description = "Small utilities for developers using KDE/Qt libs/frameworks";
    maintainers = with maintainers; [ freezeboy ];
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };
  nativeBuildInputs = [
    extra-cmake-modules
  ];
  buildInputs = [
    kdoctools
    kparts
  ];
}
