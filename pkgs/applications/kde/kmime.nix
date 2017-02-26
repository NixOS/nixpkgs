{
  kdeApp, lib,
  extra-cmake-modules, ki18n,
  kcodecs
}:

kdeApp {
  name = "kmime";
  meta = {
    license = [ lib.licenses.lgpl21 ];
    maintainers = [ lib.maintainers.ttuegel ];
  };
  nativeBuildInputs = [ extra-cmake-modules ki18n ];
  buildInputs = [ kcodecs ];
}
