{ mkDerivation, lib, extra-cmake-modules, kdoctools }:

mkDerivation {
  name = "poxml";
  meta = with lib; {
    homepage = "https://invent.kde.org/sdk/poxml";
    description = "Translate DocBook XML files using gettext PO files";
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
