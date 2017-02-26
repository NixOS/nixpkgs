{
  kdeApp, lib,
  extra-cmake-modules,
  kcompletion, kconfigwidgets, kdbusaddons, kdesignerplugin, kiconthemes,
  kio,
  boost, kitemmodels
}:

kdeApp {
  name = "akonadi";
  meta = {
    license = [ lib.licenses.lgpl21 ];
    maintainers = [ lib.maintainers.ttuegel ];
  };
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [
    kcompletion kconfigwidgets kdbusaddons kdesignerplugin kiconthemes kio
  ];
  propagatedBuildInputs = [ boost kitemmodels ];
}
