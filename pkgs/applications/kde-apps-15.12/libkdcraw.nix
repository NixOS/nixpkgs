{ kdeApp
, lib
, extra-cmake-modules
, libraw
}:

kdeApp {
  name = "libkdcraw";
  nativeBuildInputs = [
    extra-cmake-modules
  ];
  buildInputs = [
    libraw
  ];
  meta = {
    license = with lib.licenses; [ gpl2 lgpl21 bsd3 ];
    maintainers = [ lib.maintainers.ttuegel ];
  };
}
