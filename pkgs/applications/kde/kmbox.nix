{
  kdeApp, lib, kdeWrapper,
  extra-cmake-modules, kdoctools,
  kmime
}:
kdeApp {
  name = "kmbox";
  meta = {
    license = with lib.licenses; [ gpl2 lgpl21 fdl12 ];
    maintainers = [ lib.maintainers.vandenoever ];
  };
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  propagatedBuildInputs = [
    kmime
  ];
}
