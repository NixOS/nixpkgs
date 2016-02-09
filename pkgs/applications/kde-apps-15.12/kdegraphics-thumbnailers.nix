{ kdeApp
, lib
, extra-cmake-modules
, kio
, libkexiv2
, libkdcraw
}:

kdeApp {
  name = "kdegraphics-thumbnailers";
  nativeBuildInputs = [
    extra-cmake-modules
  ];
  buildInputs = [
    kio
    libkexiv2
    libkdcraw
  ];
  meta = {
    license = [ lib.licenses.lgpl21 ];
    maintainers = [ lib.maintainers.ttuegel ];
  };
}
