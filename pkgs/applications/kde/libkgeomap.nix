{ mkDerivation, lib, extra-cmake-modules, kdoctools, kio, marble, qtwebkit }:

mkDerivation {
  name = "libkgeomap";
  meta = with lib; {
    homepage = "https://invent.kde.org/graphics/libkgeomap";
    description = "Wrapper around different world-map components to browse and arrange photos over a map";
    maintainers = with maintainers; [ freezeboy ];
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };
  outputs = [ "out" "dev"  ];
  nativeBuildInputs = [
    extra-cmake-modules
  ];
  buildInputs = [
    kdoctools
    kio
    marble
    qtwebkit
  ];
}
