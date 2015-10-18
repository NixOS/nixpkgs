{ kdeApp
, lib
, cmake
}:

kdeApp {
  name = "oxygen-icons";
  nativeBuildInputs = [ cmake ];
  meta = {
    license = lib.license.lgpl3Plus;
    maintainers = [ lib.maintainers.ttuegel ];
  };
}
