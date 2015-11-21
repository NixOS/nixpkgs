{ kdeApp
, lib
, exiv2
, extra-cmake-modules
}:

kdeApp {
  name = "libkexiv2";
  nativeBuildInputs = [
    extra-cmake-modules
  ];
  buildInputs = [
    exiv2
  ];
  meta = {
    license = with lib.licenses; [ gpl2 lgpl21 bsd3 ];
    maintainers = [ lib.maintainers.ttuegel ];
  };
}
