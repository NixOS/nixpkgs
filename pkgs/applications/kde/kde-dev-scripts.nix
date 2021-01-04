{ mkDerivation, lib, extra-cmake-modules, kdoctools }:

mkDerivation {
  name = "kde-dev-scripts";
  meta = with lib; {
    homepage = "https://invent.kde.org/sdk/kde-dev-scripts";
    description = "Scripts and setting files useful during development of KDE software";
    maintainers = with maintainers; [ freezeboy ];
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };
  nativeBuildInputs = [
    extra-cmake-modules
  ];
  buildInputs = [
    kdoctools
  ];
}
